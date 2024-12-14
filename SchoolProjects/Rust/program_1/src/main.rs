/*
* Author: Jaden Yu
* Date: 9/23/2024
* Project Description: Cone volume calculator where the user inputs radius of the base and height of the cone.
* Covers invalid inputs such as negative numbers, characters, and zero. Quits the program once the user enters quit
* wherever it prompts for user input.
*/

use std::io;


fn main() {

    loop{

        println!("Enter a radius in cm (or quit to exit) : ");	//Input of the radius
    
        let mut radius = String::new();
    
        io::stdin()
            .read_line(&mut radius)
            .expect("Failed to read line");

        if radius.trim() == "quit"{				//Checks for quit condition
            break;
        }

        let radius: f64 = match radius.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("You entered an invalid measure. Please try again.\n");
                continue;
            }
        };

        if radius <= 0.0 {
            println!("You entered an invalid measure. Please try again.\n");
            continue;
        }

        println!("Enter a height in cm (or quit to exit) : ");	//Start of height input
    
        let mut height = String::new();
    
        io::stdin()
            .read_line(&mut height)
            .expect("Invalid Input, Try Again");

        if height.trim() == "quit"{				//Quit condition
            break;
        }

        let height: f64 = match height.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("You entered an invalid measure. Please try again.\n");
                continue;
            }
        };
        if height <= 0.0 {
            println!("You entered an invalid measure. Please try again.\n");
            continue;
        }

        let volume = cone_volume(radius, height);

        println!("The cone value is {:.3}\n", volume);
    }

    println!("\nGoodbye!");
}
/*
* Function: Cone Volume 
* Description: Reads in two f64 parameters and returns a f64 parameter. Uses the constant PI from the std library
* and calculates the volume of the cone and returning it.
*/
fn cone_volume(radius: f64, height: f64) -> f64 {
 
    use std::f64::consts::PI;
    
    return ((radius * radius) * height * PI) * (1.0 / 3.0);
}
