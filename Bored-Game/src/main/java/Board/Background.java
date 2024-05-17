/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Board;

import team11.bored.game.GamePanel;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

/**
 *
 * @author jaden
 */
public class Background {
    
    private GamePanel gp;
    private BufferedImage bg;
    /**
     * Constructor for the Background class, connects the Background object to the running GamePanel object
     * Also initializes the image for the background
     * @param gp current GamePanel object being used
     */
    public Background(GamePanel gp){
        this.gp = gp;
        try {
            bg = ImageIO.read(new File("src/main/java/MenuRender/Paper.png"));
        } catch (IOException e) {
            System.out.println("File not found");
        }
    }
    /**
     * Draw function that gets the Background picture and puts it onto the screen
     * Used by Game Panel class
     * 
     * @param g2 object used in order to draw the sprite
     */
    public void draw(Graphics2D g2)
    {
        g2.drawImage(bg, 0, 0, gp.screenWidth, gp.screenHeight, null);
    }
}
