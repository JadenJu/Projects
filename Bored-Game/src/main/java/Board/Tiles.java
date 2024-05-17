/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Board;

/**
 *
 * @author jaden
 */

import team11.bored.game.GamePanel;

public class Tiles {
    private int posX;
    private int posY;
    GamePanel gp;
    boolean movable = false;
    private Obstacles obsType;
    
    
    /**
     * Initializes the coordinates, the boolean statement if the tile is traversable, and the GamePanel that is being used 
     * 
     * @param X horizontal position
     * @param Y vertical position
     * @param mov if the tile is traversable by avatar object
     * @param gp current GamePanel object being used
     */
    public Tiles(int X, int Y, boolean mov, GamePanel gp)
    {
        this.gp = gp;
        posX = X;
        posY = Y;
        
        movable = mov;
    }
    /**
     * returns the x position
     * (to be used)
     * 
     * @return posX
     */
    public int getX(){
        return posX;
    }
    
    /**
     * returns the y position
     * (to be used)
     * 
     * @return posY
     */
    public int getY(){
        return posY;
    }
    
    /**
     * returns the boolean if traversable
     * (to be used)
     * 
     * @return movable
     */
    public boolean getMovable(){
        return movable;
    }
    
    /*public Tiles(int posX, int posY, Obstacles obsType, GamePanel gp)
    {
        this.gp = gp;
        this.posX = posX * gp.tileSize;
        this.posY = posY * gp.tileSize;
        
        this.obsType = obsType;
    }**/
}
