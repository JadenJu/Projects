/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Board;
/**
 *
 * @author jaden, james
 */

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import team11.bored.game.GamePanel;
import java.awt.Color;
import javax.imageio.ImageIO;
import java.io.File;


public class Avatar{
    private Characters selectedChar;
    private Tiles currentTile;
    private Path currentPath;
    private GamePanel gp;
    private int x, y;
    
    public BufferedImage sprite;
    
    /**
     * Constructor for the Avatar class, connects the avatar to the running GamePanel object
     * 
     * @param gp current GamePanel object being used
     */
    public Avatar(GamePanel gp)
    {
        this.gp = gp;
    }
    /**
     * Creates the default value for the start to pinpoint a location where the avatar will begin
     * 
     * @param start an array that holds the x y coordinates for the starting tile
     */
    public void setDefaultValues(int[] start)
    {
        x = start[1] * gp.tileSize;
        y = start[0] * gp.tileSize;  
        getPlayerImage();
    }
    /**
     * Draw function is used in the GamePanel class and is used to animate and change the sprite based on inputs
     * Updates based on the thread
     * (Animation to be implemented)
     * 
     * @param g2 object used in order to draw the sprite
     */
    public void draw(Graphics2D g2)
    {
        g2.drawImage(sprite, x, y, gp.tileSize, gp.tileSize, null);
    }
    /**
     * to be implemented
     * 
     * @param move number of spaces that need to be moved
     */
    public void moveAlongBoard(int move)
    {
        for(int i = move; i > 0; i--)
        {
            
        }
        //TODO move the avatar the number rolled from the die
        //TODO apply affect to the score based on the tile
    }
    /**
     * Gets the Buffered image from the MenuRender package
     */
    public void getPlayerImage(){
        try {
            sprite = ImageIO.read(new File("src/main/java/MenuRender/avatar1.png"));
        } catch (IOException e) {
            System.out.println("File not found");
        }
    }

}
