/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package menuModel;

/**
 *
 * @author jaden
 */
import Menu.*;

public class MainMenuModel {
    
    public void openModel(){
        MenuFrame mainMenu = new MenuFrame();
        mainMenu.setVisible(false);
        Test test = new Test();
        test.setVisible(true);
    }
    
    public void closeGame(){
        System.exit(0);
    }
        
}
