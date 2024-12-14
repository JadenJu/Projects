/*
Author: Jaden Yu
Date: 10/16/2024
Description: Creates two data structures (binary heap and queue) that contains Process structures
that are drained and its variables are printed. The queue is based on FIFO and the heap is a min heap
based on the priority integer given by the PC.
Developed in: Text Editor and Compiled in Windows terminal
Uses the dependency: rand = "0.8.5"
*/

use std::io;
use rand::Rng;
use std::collections::VecDeque;
use std::cmp::Ordering;
use std::collections::BinaryHeap;

#[derive(Eq, PartialEq)]

//Process Structure that holds all the data: processID, priority#, sleep_time, description
struct Process{
    pid: u32,
    priority: u32,
    sleep_time: u32,
    description: String,
}

//Instantiation of each structure
fn build_process(des_in: u32) -> Process {
    let prio_in = rand::thread_rng().gen_range(1..=100);		//gets a random number 1-100
    let sleep_in = rand::thread_rng().gen_range(100..=2000);		//gets a random number 100-2000
    Process {
        pid: des_in,							//gets the pid from the order the struct are made
        priority: prio_in,						//puts the prio_in random number into priority
        sleep_time: sleep_in,						//puts the random number sleep_in into sleep_time
        description: String::from(format!("Process Node: {des_in}")),	//sets description to a string that has the pid
    }
}

impl Process {
//Displays each Process object's variables
    fn print_process(&self) {
        println!("Pid:\t{},\t pri:\t{},\t sleep:\t{},\t desc: {}", self.pid, self.priority, self.sleep_time, self.description);
    }
}


//Trait for Binary Heap: Ord that gets the priority integer and compares it so that the binary heap becomes a minHeap
impl Ord for Process {
    fn cmp(&self, other: &Self) -> Ordering {
        other.priority.cmp(&self.priority)
            .then_with(|| self.description.cmp(&other.description))
    }
}

//Trait for the binary heap to change it into a minHeap
impl PartialOrd for Process {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn main() {

//Start of the program and asks for user input for # of nodes
    println!("Enter the number of process nodes to generate:");

    let mut nodes = String::new();

    io::stdin()
        .read_line(&mut nodes)
        .expect("Failed to read line");
//string parse, if there is an error then the program exits
    let nodes: u32 = match nodes.trim().parse() {
        Ok(num) => num,
            Err(_) => {
            println!("You entered an invalid input.\n");
            return;
        }
    };

//Start of Queue creation
    println!("Now creating and adding {} process nodes to a Queue and to a binary minheap", nodes);
    
    print!("Verifying. \t");

    let mut index = 1;				//used for priority id for Process struct
    let mut deque: VecDeque<Process> = VecDeque::with_capacity(nodes.try_into().unwrap());	//instantiates the queue with a capacity of the user input (nodes)
    
//Filling up the queue with Process objects
    while index <= nodes {
        deque.push_back(build_process(index));			
        index += 1;
    }

    println!("The queue contains {} elements", deque.len());		//ensures that the queue is filled

    print!("Verifying. \t");

    let mut min_heap = BinaryHeap::new();	//instantiates the min heap

//Filling the heap with Process objects
    index = 1;
    while index <= nodes {
        min_heap.push(build_process(index));
        index += 1;
    }

    println!("The minheap contains {} elements", min_heap.len());	//ensures that the heap is filled

//drains both queue and heap from the first element (FIFO for queue and pop from the top with the heap)
    println!("\nNow, draining the Queue, one process at a time...");
    while !deque.is_empty(){
        deque.pop_front().unwrap().print_process();
    }

    println!("\nNow, draining the MinHeap, one process at a time...");

    while !min_heap.is_empty(){
        min_heap.pop().unwrap().print_process();
    }

    println!("\nGoodbye.");
    
}
