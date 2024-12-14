/*
Jaden Yu
10/3/2024
10/7/2024 - added Player count and fixed a bug where cap made the arrays go out of index (changed code to len)
Tested on: Windows 10.0.190
Program Name: program1
Program 1: Baseball Statistics
Description: This program contains one user input that will repeat if the input is faulty. The input should be a file path that
contains information of the baseball players statistics. The file will be read into the program and the data will be put into a
Player structure. Then using the data the batting average, slugging statistic, and on base percentage will be calculated. The output
will be ordered in slugging percentage. Errors will be caught by invalid inputs or not enough information. This information will
be printed at the end of the program
*/

package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

type Player struct { //Player structure to organize the information for each player
	firstName, lastName, errorType string
	playerStats                    [8]int64 //stats: 0-plateAppearance, 1-atBats, 2-singles, 3-doubles, 4-triples, 5-homeruns, 6-walks, 7-hitByPitch
	battingAvg, slugging, obp      float64
	errorChecker                   bool
	errorLine                      int
}

// Sorting information, sets up a class for sorting and setting up the information to be sorted by slugging (Used by sort.Slice)
type BySlugging []Player

func (a BySlugging) Len() int           { return len(a) }
func (a BySlugging) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a BySlugging) Less(i, j int) bool { return a[i].slugging < a[j].slugging }

/* Initialize is the function that inputs information into each Player object. It also checks for both error types*/
func (p *Player) Initialize(input string) {
	var eCheck error                        //error variable that will check for a wrong parse/character
	components := strings.Split(input, " ") //splits the string into an array
	p.firstName = components[0]             //inputs the first two strings into the first and last name variables of the Player
	p.lastName = components[1]

	if len(components) < 10 {
		p.errorChecker = true //sets flag that error occured
		p.errorType = "Line does not contain enough data."
		return
	}

	for i := 0; i < 8; i++ {
		p.playerStats[i], eCheck = strconv.ParseInt(components[i+2], 10, 64) //Parses string that was inputed into int and puts into player statistics
		if eCheck != nil {                                                   //if an error is found
			p.errorChecker = true //sets flag that error occured
			p.errorType = "Line contains invalid data."
			return
		}
	}
}

/* Calculator that puts all information needed for the output into corresponding variables*/
func (p *Player) Calculator() {
	p.battingAvg = float64(p.playerStats[2]+p.playerStats[3]+p.playerStats[4]+p.playerStats[5]) / float64(p.playerStats[1])
	p.slugging = float64(p.playerStats[2]+2*p.playerStats[3]+3*p.playerStats[4]+4*p.playerStats[5]) / float64(p.playerStats[1])
	p.obp = float64(p.playerStats[2]+p.playerStats[3]+p.playerStats[4]+p.playerStats[5]+p.playerStats[6]+p.playerStats[7]) / float64(p.playerStats[0])
}

/* Stores the line the error occurs at*/
func (p *Player) ErrorLine(j int) { p.errorLine = j }

func main() {
	var keyboard *bufio.Scanner  //user input
	var fileName string          //stores filename
	var estat error              //checks for error in filepath
	var inFile *os.File          //finds the actual file
	var fileLines *bufio.Scanner //used for file input
	var playerList []Player      //List of Player objects
	var errCount int             //counts the errors that occurs for the error outputs

	errCount = 0 //initialize errCount

	keyboard = bufio.NewScanner(os.Stdin)

	/* File input procedure: asks for a file path, if it fails then the loop continues, if it succeeds it breaks, if q is entered the program
	will end*/
	for {
		fmt.Print("\nEnter a file path (q to quit): ")
		keyboard.Scan()
		fileName = keyboard.Text()

		if fileName == "q" {
			return
		}
		inFile, estat = os.Open(fileName)
		if estat != nil {
			fmt.Println("\nI was unable to open the file named " + fileName)
			fmt.Println("Try Again")
			continue
		} else {
			break
		}
	}

	defer inFile.Close()
	fileLines = bufio.NewScanner(inFile) //prepares for file input

	/* Goes through the file and creates a list that will grow with each input. Initializes, finds the important stats for output, and finds
	   the error lines/count for the whole program*/
	for i := 0; true; i++ {

		fileLines.Scan()

		if fileLines.Text() == "" {
			break
		}
		playerList = append(playerList, Player{}) //dynamic allocation of Player object into the list
		playerList[i].Initialize(fileLines.Text())
		if !playerList[i].errorChecker {
			playerList[i].Calculator()
		} else {
			playerList[i].ErrorLine(i + 1)
			errCount++
		}

	}
	inFile.Close() //closes the file
	/* Sort using the sort library*/

	sort.Slice(playerList, func(i, j int) bool {
		return playerList[i].slugging > playerList[j].slugging //uses the slugging stat for sort
	})

	/*output layout*/
	fmt.Println(fmt.Sprintf("\n\nBASEBALL STATS REPORT --- %d PLAYERS FOUND IN FILE \n", len(playerList)-errCount))
	fmt.Println("\tPLAYER NAME\t:\tAVERAGE\tSLUGGING ONBASE%")
	fmt.Println("-------------------------------------------------------")
	/*output for good data*/
	for i := 0; i < len(playerList)-errCount; i++ {
		fmt.Println(fmt.Sprintf("\t%s, %s\t:\t%.3f\t %.3f    %.3f", playerList[i].firstName, playerList[i].lastName, playerList[i].battingAvg, playerList[i].slugging, playerList[i].obp))
	}
	/*error outputs*/
	fmt.Println("ERROR LINES FOUND IN INPUT DATA")
	fmt.Println("-------------------------------------------------------")
	for i := len(playerList) - errCount; i < len(playerList); i++ {
		fmt.Println(fmt.Sprintf("\tLine %d\t%s, %s\t:\t%s", playerList[i].errorLine, playerList[i].firstName, playerList[i].lastName, playerList[i].errorType))
	}
}
