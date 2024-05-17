/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package BackgrndCalcs;

import java.util.Random;
/**
 *
 * @author jaden/Shane
 */
public class Dice {
    public final int max_num = 6; //Max number the die can give
    /**
     * finds a number from 1 - a set max number that is then returned to be used
     * by the Avatar to change its position
     * 
     * 
     * @return a number from 1 - the max number set by the programmer
     */
    public int rollDice()
    {
        //Creates new random class and finds random value between 1 and max_num
        Random rand = new Random();
        return rand.nextInt(1, max_num); //Finds random number between 1 and max_num
    }
}
