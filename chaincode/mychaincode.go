package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

type MyContract struct {
}

type User struct {
	RollNo    int64  `json:"rollNo"`
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
}

// Initialize ledger
func (contract *MyContract) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success([]byte("Chaincode initialized"))
}

// This function will be called when user query or add any user data
func (contract *MyContract) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	fun, args := stub.GetFunctionAndParameters()

	if fun == "addUser" {
		return addUser(stub, args)
	} else if fun == "getUser" {
		return getUser(stub, args)
	} else if fun == "listAllUsers" {
		return listAllUsers(stub)
	} else if fun == "deleteUser" {
		return deleteUser(stub, args)
	}

	return shim.Error("Invalid Function name")
}

// This function will add a user in ledger
// This function can also be used to update ledger
func addUser(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	if len(args) != 3 {
		return shim.Error("Required args ==> 3")
	}
	//convert rollno to int
	rollNo, err := strconv.ParseInt(args[0], 10, 64)

	if err != nil {
		fmt.Println("Error while converting rollno to int ", err)
		return shim.Error("Error while converting rollno to int")
	}

	fmt.Println("Rollno is ==> ", rollNo)

	user := User{RollNo: rollNo, FirstName: args[1], LastName: args[2]}

	userBytes, err := json.Marshal(user)

	if err != nil {
		fmt.Println("Error while converting json", err)
	}
	stub.PutState(args[0], userBytes)

	return shim.Success([]byte("Rollno converted to int"))

	return shim.Success([]byte("Done"))

}

//   This function will fetch the user from statedb
func getUser(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	if len(args) != 1 {
		return shim.Error("Please provide a user id")
	}

	byteValue, err := stub.GetState(args[0])

	if err != nil {
		return shim.Error(err.Error())
	} else if len(byteValue) == 0 {
		return shim.Error("Record Not Found")
	}

	return shim.Success(byteValue)
}

// This function will show all the users in ledger
func listAllUsers(stub shim.ChaincodeStubInterface) peer.Response {

	queryIterator, err := stub.GetQueryResult("{\"selector\":{}}")

	if err != nil {
		fmt.Println("Error occured ==> ", err)
		return shim.Error(err.Error())
	}

	var buffer bytes.Buffer

	buffer.WriteString("[")

	isFirstRecord := true

	for queryIterator.HasNext() {
		queryResult, _ := queryIterator.Next()

		if !isFirstRecord {
			buffer.WriteString(",")
		}

		buffer.WriteString("{\"key\":")
		buffer.WriteString("\"")

		buffer.WriteString(queryResult.Key)

		buffer.WriteString("\",")
		buffer.WriteString("\"value\":")
		buffer.WriteString(string(queryResult.Value))
		buffer.WriteString("}")

		isFirstRecord = false
	}

	buffer.WriteString("]")
	fmt.Println("Records ==> ", buffer.String())

	return shim.Success([]byte(buffer.String()))
}

// This function will delete user from ledger
func deleteUser(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	if len(args) != 1 {
		return shim.Error("Please provide the user id")
	}

	err := stub.DelState(args[0])

	if err != nil {
		return shim.Error(err.Error())
	}

	var msgBytes bytes.Buffer

	msgBytes.WriteString("User with id")
	msgBytes.WriteString(args[0])
	msgBytes.WriteString(" deleted successfully")

	return shim.Success([]byte(msgBytes.String()))
}

// func updateUser(stub shim.ChaincodeStubInterface, args []string) peer.Response {

// }

func main() {

	err := shim.Start(new(MyContract))

	if err != nil {
		fmt.Printf("Error ==> %s", err)
	}
}
