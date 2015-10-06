/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * BaseStepContentPanel.java
 *
 * Created on May 14, 2010, 5:31:50 PM
 */

package MainProgram.Walkthrough.UI.StepContentPanels;

import MainProgram.Map.MapData;
import MainProgram.Walkthrough.UI.WalkthroughWindow;
import java.awt.Component;
import java.awt.Container;
import java.util.ArrayList;
import javax.swing.JScrollPane;

/**
 *
 * @author Stephen
 */
public class BaseStepContentPanel extends javax.swing.JPanel {

    WalkthroughWindow m_walkthroughWindow = null;
    /** Creates new form BaseStepContentPanel */
    public BaseStepContentPanel()
    {
        initComponents();
    }
    public Boolean SendGMessage(Object obj)
    {
        return true;
    }
    public void SetWalkthroughWindow(WalkthroughWindow window)
    {
        m_walkthroughWindow = window;
    }
    public boolean WaitForPanelClose()
    {
        return true;
    }
    public void InitControls()
    {
    }
    public void ScrollPaneToLastMapPos(JScrollPane c)
    {
        c.getViewport().setViewPosition(m_walkthroughWindow.GetProject().GetProjectInfo().LastMapDisplayAreaPoint);
    }
    /*public void InitKeyListeners()
    {
        KeyAdapter keyPressed = new KeyAdapter()
        {
            @Override
            public void keyPressed(KeyEvent e)
            {
                super.keyPressed(e);
                AlertKeyPressed(e);
            }
        };
        for(Component cur : FindAncestors3OrLessDeep(this))
        {
            cur.removeKeyListener(keyPressed);
            cur.addKeyListener(keyPressed);
        }
    }*/
    private Component[] FindAncestors3OrLessDeep(Component p)
    {
        ArrayList<Component> result = new ArrayList<Component>();
        if (p instanceof Container)
        {
            for (Component l1c : ((Container) p).getComponents())
            {
                result.add(l1c);
                if (l1c instanceof Container)
                {
                    for (Component l2c : ((Container) l1c).getComponents())
                    {
                        result.add(l2c);
                        if (l2c instanceof Container)
                        {
                            for (Component l3c : ((Container) l2c).getComponents())
                            {
                                result.add(l3c);
                            }
                        }
                    }
                }
            }
        }
        Component[] empty = new Component[0];
        return result.toArray(empty);
    }
    public void ProcessControlContentToMapData()
    {
    }
    public void AlertKeyPressed(java.awt.event.KeyEvent evt)
    {
    }
    public MapData GetMapData()
    {
        return m_walkthroughWindow.GetProject().GetMapData();
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setName("Form"); // NOI18N

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 725, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 352, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables

}
