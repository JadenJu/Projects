/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package team11.bored.game;

/**
 * The main brain of the game program
 * 
 * @author jaden, james
 */

import Board.Path;
import Board.Avatar;
import Board.Background;
import java.awt.Dimension;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.JPanel;

public class GamePanel extends JPanel implements Runnable{
    
    final int originalTileSize = 16;
    final int scale = 3;
    
    final public int tileSize = originalTileSize * scale;
    final public int maxScreenCol = 16;
    final public int maxScreenRow = 12;
    final public int screenWidth = tileSize * maxScreenCol;
    final public int screenHeight = tileSize * maxScreenRow;
    
    Path path = new Path(this);
    Avatar player = new Avatar(this);
    Background bg = new Background(this);
    
    
    int FPS = 12;
    
    Thread gameThread;
    
    
    /**
     * sets up the size, the background, and DoubleBuffered is set true for load time
     */
    public GamePanel(){
        
        this.setPreferredSize(new Dimension(screenWidth, screenHeight));
        this.setBackground(Color.black);
        this.setDoubleBuffered(true);
    }
    
    /**
     * Starts the thread and allows for time to be measured
     */
    public void startGameThread(){
     gameThread = new Thread(this);
     gameThread.start();
     
    }
    
    
    /**
     * What continuously updates the program
     * Creates an interval of time that dictates the FPS that is to be used
     * If an exception appears it will log it and will throw the program if necessary
     * 
     */
    @Override
    public void run() {
        double drawInterval = 1000000000/FPS;
        double nextDrawTime = System.nanoTime() + drawInterval;
        double remainingTime;
        
        //while(gameThread != null)
        //{            
            update();
            
            repaint();
            try {
                remainingTime = nextDrawTime - System.nanoTime();
                remainingTime = remainingTime/1000000;
            
                if(remainingTime < 0)
                    remainingTime = 0;
 
                Thread.sleep((long)remainingTime);
                
                nextDrawTime += drawInterval;
                
            } catch (InterruptedException ex) {
                Logger.getLogger(GamePanel.class.getName()).log(Level.SEVERE, null, ex);
            }

        //}
    }
    /**
     * used in run method
     */
    public void update(){
        
    }
    
    /**
     * This creates the images onto the screen that the background object, the path object, and the avatar object (player)
     * have in their draw methods
     * 
     * @param g used to draw and paint the components
     * @see Background, pathing, and the player avatar
     */
    public void paintComponent(Graphics g){
        
        super.paintComponent(g);
        
        Graphics2D g2 = (Graphics2D)g;
        
        bg.draw(g2);
        
        path.draw(g2);
        
        player.setDefaultValues(path.startPanel);
        player.draw(g2);
        
        
    }
    
}
