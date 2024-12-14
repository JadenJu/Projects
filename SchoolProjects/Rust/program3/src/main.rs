/*
Author: Jaden Yu
Date: 11/11/2024
Description: Producer and consumer program where the user inputs how many generation phases happen 
and how many processes are generated in each phase. There is one producer and two consumers
where the consumers run the processes until completion.
Developed in: Text Editor and Compiled in Windows terminal
Uses the dependency: rand = "0.8.5"
*/

use std::io;
use rand::Rng;
use std::sync::{Arc, Mutex};
use std::thread;				
use std::time::Duration;
use std::cmp::Ordering;
use std::collections::BinaryHeap;

#[derive(Eq, PartialEq)]

//Process Structure that holds all the data: processID, priority#, sleep_time, description
struct Process{
    pid: u32,
    priority: u32,
    sleep_time: u64,
}

//Instantiation of each structure
fn build_process(des_in: u32) -> Process {
    let prio_in = rand::thread_rng().gen_range(0..=100);		//gets a random number 1-100
    let sleep_in = rand::thread_rng().gen_range(200..=2000);		//gets a random number 100-2000
    Process {
        pid: des_in,							//gets the pid from the order the struct are made
        priority: prio_in,						//puts the prio_in random number into priority
        sleep_time: sleep_in,						//puts the random number sleep_in into sleep_time
    }
}

impl Process {
//returns the sleep time
    fn consumed(&self) -> u64 {
	self.sleep_time
    }
//Prints out that the process was complete
    fn printing(&self) {
	println!("executed process {}, pri: {},for {} ms", self.pid, self.priority, self.sleep_time);
    }

}

//Trait for Binary Heap: Ord that gets the priority integer and compares it so that the binary heap becomes a minHeap
impl Ord for Process {
    fn cmp(&self, other: &Self) -> Ordering {
        other.priority.cmp(&self.priority)
            .then_with(|| self.pid.cmp(&other.pid))
    }
}

//Trait for the binary heap to change it into a minHeap
impl PartialOrd for Process {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn main() {

//Gets M from user input
    println!("Enter the number of generation phases for the producer:");

    let mut phases = String::new();

    io::stdin()
        .read_line(&mut phases)
        .expect("Failed to read line");
//string parse, if there is an error then the program exits
    let phases: u32 = match phases.trim().parse() {
        Ok(num) => num,
            Err(_) => {
            println!("You entered an invalid input.\n");
            return;
        }
    };

//Gets S from user input
    println!("Enter sleep time in ms for the producer to pause between generation phases:");

    let mut sleep_t = String::new();

    io::stdin()
        .read_line(&mut sleep_t)
        .expect("Failed to read line");
//string parse, if there is an error then the program exits
    let sleep_t: u64 = match sleep_t.trim().parse() {
        Ok(num) => num,
            Err(_) => {
            println!("You entered an invalid input.\n");
            return;
        }
    };

//Gets N from user input
    println!("Enter number of processes to generate each phase:");

    let mut processes = String::new();

    io::stdin()
        .read_line(&mut processes)
        .expect("Failed to read line");
//string parse, if there is an error then the program exits
    let processes: u32 = match processes.trim().parse() {
        Ok(num) => num,
            Err(_) => {
            println!("You entered an invalid input.\n");
            return;
        }
    };

    let process_quant = phases * processes;	//Gets the total nodes created for the end of producer thread

    let mut index = 1;				//used for priority id for Process struct
    let shared_heap = Arc::new(Mutex::new(BinaryHeap::<Process>::new()));	//shared heap for threads

    let heap_clone1 = Arc::clone(&shared_heap);			//clone of the shared binary heap

//start of producer thread
    let thread_producer = thread::spawn( move || {
	for _ in 1..=phases {					//thread repeats M times
		{ // BEGIN CRITICAL REGION 
		    let mut heap = heap_clone1.lock().unwrap();	//locks the binary heap
	       	    let mut count = 0;				//used for loop condition
		    while count < processes{
			heap.push(build_process(index));	//pushes in a new process onto heap
			index += 1;
			count += 1;
		    }
		    
		} // END CRITICAL REGION
	    println!("\n... sleeping producer thread ...\n");
            thread::sleep(Duration::from_millis(sleep_t));  // Sleeps for S ms
        }
    });

//consumer1 thread
    let heap_clone2 = Arc::clone(&shared_heap);			//clone of the shared binary heap
    let thread_consumer1 = thread::spawn( move || {
	let mut count = 0;					//counts how many nodes were executed by thread
	for _ in 1.. {
	    let sleep;						//holds sleep time for thread
	    let process1;					//holds popped process
		{ // BEGIN CRITICAL REGION 
		    let mut heap = heap_clone2.lock().unwrap();	//locks heap from other threads
		    if heap.is_empty() {
			thread::sleep(Duration::from_millis(1000));	//sleeps thread to buffer the last process to finish printing
			println!("\n...Consumer1 has completed and executed {} processes", count);
			break;
		    }
		    process1 = heap.pop().unwrap();
	       	    sleep = process1.consumed();	//gets sleep time from object
		    count += 1;
		} // END CRITICAL REGION
	    thread::sleep(Duration::from_millis(sleep));	//sleeps thread based on the time in the object
	    print!("\tConsumer1: ");				//prints out execution statement
	    process1.printing();
        }
    });

    let heap_clone3 = Arc::clone(&shared_heap);			//clone of the shared binary heap
    let thread_consumer2 = thread::spawn( move || {
	let mut count = 0;					//counts how many nodes were executed by thread
	for _ in 1.. {
	    let sleep;						//holds sleep time for thread
	    let process2;
		{ // BEGIN CRITICAL REGION 
		    let mut heap = heap_clone3.lock().unwrap();	//locks heap from other threads
		    if heap.is_empty() {
			thread::sleep(Duration::from_millis(1000));	//sleeps thread to buffer the last process to finish printing
			println!("\n...Consumer2 has completed and executed {} processes", count);
			break;
		    }
		    process2 = heap.pop().unwrap();
	       	    sleep = process2.consumed();	//gets sleep time from object
		    count += 1;
		} // END CRITICAL REGION
	    thread::sleep(Duration::from_millis(sleep));	//sleeps thread based on the time in the object
	    print!("\t\tConsumer2: ");				//prints out execution statement
	    process2.printing();
        }
    });


    println!("Starting Simulation\n");
    println!("... starting producer thread ...");
    thread_producer.join().unwrap();				//producer thread stops here
    println!("\n... producer has finished: {} nodes were generated ...\n", process_quant);
//consumer threads stop here
    thread_consumer1.join().unwrap();
    thread_consumer2.join().unwrap();
    
    
}
