
import javax.swing.JFrame;
import javax.swing.WindowConstants;

/**
 *  GUI window
 * 
 * @author Sidney
 * @version 1.0
 */
public class MainFrame extends JFrame {
    public void init () {
        setTitle("BoredGame");
        setSize (450,300);
        setDefaultCloseOperation (WindowConstants.EXIT_ON_CLOSE);
        setVisible (true);
    }
}
