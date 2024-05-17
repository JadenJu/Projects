/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package BackgrndCalcs;

import java.awt.image.BufferedImage;

/**
 *
 * @author jaden
 */
public class SpriteSheet {
    
    private BufferedImage image;
    /**
     * A constructor that calls for the spriteSheet in order to hold it in the private variable image;
     * 
     * @param image a BufferedImage object that is used to hold the spriteSheet wanted
     */
    public SpriteSheet(BufferedImage image){
        this.image = image;
    }
    /**
     * (To be implemented)
     * The purpose of this class is to get a sprite sheet from the package MenuRender and to 
     * splice out an image that would ultimately animate the avatar or choose a picture for the tile
     * Currently having pathing problems
     * 
     * @param col integer that holds the wanted column
     * @param row integer that holds the wanted row
     * @param width integer that gets the width of the image
     * @param height integer that gets the height of the image
     * @return img a spliced image from the spriteSheet
     */
    public BufferedImage grabImage(int col, int row, int width, int height){
        
        BufferedImage img = image.getSubimage((col*16)-16, (row*16) - 16, width, height);
        return img;
    }
    
}
