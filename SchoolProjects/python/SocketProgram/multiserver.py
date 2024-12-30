# Author: Jaden Yu
# Program: multiserver.py
# Description: A server that can hold multiple clients thet are able to communicate with each other.
# Makes use of multithreading in order to Listen to each individual client.


import socket
import time
from threading import Thread

class Server:
    Clients = []            #List to keep track of clients in the server
#Constructor for the server
    def __init__(self, HOST, PORT):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)         #Sets up the socket for the server object
        self.socket.bind((HOST, PORT))                                          #Binds the socket to the host IP and port
        self.socket.listen(5)                                                   #Socket listens for new clients up to five
        print('Server waiting for connection....')                              
#Listen function so that the server can start and listen for clients
    def listen(self):
        while True:
            client_socket, address = self.socket.accept()                       #Server accepts client socket
            print("Connection from: " + str(address))                           #Print out the address of the client socket

            client_name = "ID" + str(len(Server.Clients))                       #Creates the client ID
            client = {'client_name': client_name, 'client_socket': client_socket, 'client_address': str(address)}       #Create client object to put into server list for clients

            Server.Clients.append(client)                                       #Add client object to the list
            Thread(target = self.handle_new_client, args = (client,)).start()   #Start a new thread for each client
#Function used in order to start the thread and handle each client independently
    def handle_new_client(self, client):
        #Initialization of variables in order to extract information from The Client object
        client_name = client['client_name']
        client_socket = client['client_socket']
        client_address = client['client_address']
        receiver_name = client_name                 #Variable used to keep track of who the Current client wants to message
        self.message_send("Welcome " + client_name, client_name, client_name)
        while True:
            client_message = client_socket.recv(1024).decode()          #Decode the message received from client
            print(client_message + " From: " + client_name + client_address)        #Close the message received and the client ID along with its address to the server screen
            receiver_name = self.message_receive(client_message, receiver_name, client_name)        #Receives the message and then decides whether to change the receiver name variable
            
#Function used to receive messages and also determine whether to change the receiver of the client's message
    def message_receive(self, message, receiver_name, sender_name):
        if message == "list" or message == "List":                  #If statement checks for list command from client
            for client in self.Clients:                             #Prints out all the clients names in a list
                self.message_send(client['client_name'], sender_name, sender_name)
            return client['client_name']                            #Returns the previous client name as as there is no change to desired receiver
        for client in self.Clients:                                 #Checks if the message sent matches any of the clients inside of the list if there is a name returns the new name into receiver name
            client_name = client['client_name']
            if message == client_name:
                return client_name
        self.message_send("From " + sender_name + ": " + message, receiver_name, sender_name)    #If none of the above Events happen then send message Function is activated and receiver is the same
        return receiver_name
#Sends the message to whichever client it needs
    def message_send(self, message, receiver_name, sender_name):
       for client in self.Clients:                                  #Finds the client and receiver and then sends message packet out to desired receiver
            client_socket = client['client_socket']
            client_name = client['client_name'] 
            if receiver_name != sender_name and client_name == sender_name:
                time.sleep(.1)                                      #delays in order to stop crowding
                client_socket.send(message.encode())                #Send message back to sender client
            if client_name == receiver_name:
                time.sleep(.1)                                      #delays in order to stop crowding
                client_socket.send(message.encode())                #sends message to client socket

#Main function
if __name__== '__main__':
    server = Server('127.0.0.1', 65432)     #Initialises the server with IP address 127.0.0.1 and the port to 65432 This can be changed with args value in cmd window if wanted
    server.listen()                         #Starts the server