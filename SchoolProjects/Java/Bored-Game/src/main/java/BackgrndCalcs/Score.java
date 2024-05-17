/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package BackgrndCalcs;

/**
 *
 * @author jaden
 */

public class Score {
    private int highScore;
    private int currentScore;
    /**
     * Sets the highScore depending on if the current score is larger     * 
     * 
     * @param score an integer that will change the high score depending on if it's larger
     */
    public void setHighScore(int score)
    {
        if(highScore < currentScore)
            highScore = currentScore;
    }
    
    /**
     * to be implemented
     * 
     * @see highScore
     */
    public int displayHighestScore()
    {
        //TODO implement a graphic to constantly display a highscore
        return highScore;
    }
    /**
     * to be implemented
     * 
     * @see currentScore
     */
    public int displayCurrentScore()
    {
        //TODO implement a graphic to constantly display currentScore
        return currentScore;
    }
    
    
}
