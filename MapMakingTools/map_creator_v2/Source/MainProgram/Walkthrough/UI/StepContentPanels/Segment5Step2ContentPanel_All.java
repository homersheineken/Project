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

import javax.swing.JScrollPane;

/**
 *
 * @author Stephen
 */
public class Segment5Step2ContentPanel_All extends BaseStepContentPanel
{
    public Segment5Step2ContentPanel_All()
    {
        initComponents();
    }
    
    @Override
    public boolean WaitForPanelClose()
    {
        return true;
    }
    
    @Override
    public void InitControls()
    {
    }

    @Override
    public void ProcessControlContentToMapData()
    {
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        v_tillThen1 = new javax.swing.JTextArea();

        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance().getContext().getResourceMap(Segment5Step2ContentPanel_All.class);
        jLabel1.setText(resourceMap.getString("jLabel1.text")); // NOI18N
        jLabel1.setName("jLabel1"); // NOI18N

        jScrollPane2.setBorder(null);
        jScrollPane2.setName("jScrollPane2"); // NOI18N

        v_tillThen1.setBackground(resourceMap.getColor("v_tillThen1.background")); // NOI18N
        v_tillThen1.setColumns(20);
        v_tillThen1.setEditable(false);
        v_tillThen1.setFont(resourceMap.getFont("v_tillThen1.font")); // NOI18N
        v_tillThen1.setLineWrap(true);
        v_tillThen1.setRows(5);
        v_tillThen1.setText(resourceMap.getString("v_tillThen1.text")); // NOI18N
        v_tillThen1.setWrapStyleWord(true);
        v_tillThen1.setBorder(null);
        v_tillThen1.setDisabledTextColor(resourceMap.getColor("v_tillThen1.disabledTextColor")); // NOI18N
        v_tillThen1.setFocusable(false);
        v_tillThen1.setName("v_tillThen1"); // NOI18N
        jScrollPane2.setViewportView(v_tillThen1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 552, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1))
                .addContainerGap(163, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 215, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(101, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTextArea v_tillThen1;
    // End of variables declaration//GEN-END:variables
}
