/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package BackgrndCalcs;

/**
 * To be implemented
 * 
 * 
 * @author jaden
 */
public class Turn {
    private static int firstPlayer;
    private int playerTurn;
    private int nextPlayer;
    private int turnNumber;
    
    private void advanceTurn()
    {
        //TODO check who is the next player in the sequence
        //TODO change the player sequence to the nextPlayer
        //TODO change the nextPlayer to the player after
        //TODO increment turn Number if rotation is finished 
        //TODO call resetTurn()
    }
    
    private void setTurn()
    {
        //TODO change to the next turn
    }
    
    public int getFirstPlayer()
    {
        return firstPlayer;
    }
    
    public int getTurnNum()
    {
        return turnNumber;
    }
    
    private void resetTurn()
    {
        //TODO reset the turn to the firstPlayer
    }
    
}
