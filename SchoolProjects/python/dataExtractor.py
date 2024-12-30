# Author: Jaden Yu
# Program Name: dataExtractor.py
# Date: 10/25/2024
# Program Description: This program opens three files, two to write to each containing emails and phone numbers respectively and a file that reads byte data.
# Then the program reads in the data and converts back to ascii. Finally, the program uses RegEx in order to find specific values to find emails and phone numbers.
# These values are then written to the write only files.

import regex
import io

# initializes the write files
emails = open("emails.txt", 'w')
phones = open("phones.txt", 'w')

# opening the files needed for the program, however a failsafe is created that gives the user the ability to find the file through the filepath
try:
    file = open("usb256.001", "rb")
except:
    print("Could not open file")
    try:
        filename = input("Please try typing out the file path: ")
        file = open(filename, "rb")
    except:
        print("Opening the file has failed")
        SystemExit

        
with file:
    binary_data = file.read()                                                               # read of the binary file

    text_data = binary_data.decode("ascii", errors="ignore")                                # changes file to ascii

    print("Starting Email Search...")
    pattern1 = regex.compile(r"[A-Za-z0-9._]+@[A-Za-z0-9._]+\.[A-va-v]{2,4}\b")           # regEx pattern that will be used to find Emails
    matches = pattern1.findall(text_data)                                                   # matches will hold all the data that holds the emails
    print("Starting Write to File...")
    emails.writelines([f"{line}\n" for line in matches])                                    # Writes out the data in matches to email outfile

    print("Starting Phone# Search...")
    #pattern2 = regex.compile(r"\(?\d{3}\)?[.\- ]{1}\d{3}[.\-]{1}\d{4}")                        # Phone number regEx
    pattern2 = regex.compile(r"\(?\d{3}\)?[.\- ]{1}\d{3}[.\-]{1}\d{4}")                        # Phone number regEx
    matches = pattern2.findall(text_data)                                                   # matches for the phone number
    print("Starting Write to File...")
    phones.writelines([f"{line}\n" for line in matches])                                    # writes lines to phone number outfile