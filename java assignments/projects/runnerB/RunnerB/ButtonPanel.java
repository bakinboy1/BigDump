// Copyright (c) 2012, David E. Woolbright
//  All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are permitted 
// provided that the following conditions are met:
// - Redistributions of source code must retain the above copyright notice, this list of conditions 
//   and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice, this list of conditions 
//   and the following disclaimer in the documentation and/or other materials provided with the 
//   distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
// IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 
// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import javax.swing.JOptionPane;
import java.util.Scanner;

public class ButtonPanel extends JPanel
{
    private CPU cpu;
    private JTextField programName;
    private MemoryPanel mp;
    private PSWPanel pswp;
    private RegisterPanel rp;
    private JButton cycleButton;
    private JButton loadButton;
    private JButton reloadButton;
    private JButton resetPSWButton;
    private JButton fetchButton;
    private JButton decodeButton;
    private JButton executeButton;
    private JButton setStopButton;
    private JButton goToStopButton;
    private JButton clearStopButton;
    private String fName;  //the file name
    private String stopAddress;
    private boolean stopSet;
    private PSWPanel pswPanel;

    public ButtonPanel(CPU cpu, MemoryPanel mp, PSWPanel pswp, RegisterPanel rp)
    {
        this.cpu = cpu;
        this.mp = mp;
        this.pswp = pswp;
        this.rp = rp;
        int fontsize = 14;
        setBackground(new Color(Integer.parseInt("7DBBCF",16))); 
        setLayout(new BoxLayout(this, BoxLayout.LINE_AXIS));
        //setLayout(new BoxLayout(this, BoxLayout.LINE_AXIS));
        Toolkit tk = Toolkit.getDefaultToolkit();
        Dimension d = tk.getScreenSize();
        int width = (int) d.getWidth();
        int height = (int) (d.getHeight() * .04); 
        setPreferredSize(new Dimension(width,height));        
        //setPreferredSize (new Dimension(1500,50));
        cycleButton = new JButton("Cycle");
        cycleButton.setFont(new Font("Courier", Font.BOLD, Runner.FONT0));
        cycleButton.addActionListener(new CycleButtonListener());
        cycleButton.setEnabled(false);
        loadButton = new JButton("Load Program");
        loadButton.setFont(new Font("Courier", Font.BOLD, Runner.FONT0));
        loadButton.addActionListener(new LoadButtonListener()); 
        loadButton.setEnabled(true);
        reloadButton = new JButton("Reload Program");
        reloadButton.setFont(new Font("Courier", Font.BOLD, Runner.FONT0));
        reloadButton.addActionListener(new ReloadButtonListener()); 
        reloadButton.setEnabled(false);        
        resetPSWButton = new JButton("Reset PSW");
        resetPSWButton.setFont(new Font("Courier", Font.BOLD, Runner.FONT0));
        resetPSWButton.addActionListener(new ResetPSWButtonListener());
        resetPSWButton.setEnabled(false);
        setStopButton = new JButton("Set Stop");
        setStopButton.setFont(new Font("Courier", Font.BOLD, Runner.FONT0));
        setStopButton.addActionListener(new SetStopButtonListener());
        setStopButton.setEnabled(false);    
        goToStopButton = new JButton("Go To Stop");
        goToStopButton.setFont(new Font("Courier", Font.BOLD, Runner.FONT0));
        goToStopButton.addActionListener(new GoToStopButtonListener());
        goToStopButton.setEnabled(false);     
        clearStopButton = new JButton("Clear Stop");
        clearStopButton.setFont(new Font("Courier", Font.BOLD, Runner.FONT0));
        clearStopButton.addActionListener(new ClearStopButtonListener());
        clearStopButton.setEnabled(false);   
        stopSet = false;
        
//         JLabel progLabel = new JLabel("Program Name: ");
//         progLabel.setFont(new Font("Courier", Font.BOLD, 24));           
//         add(progLabel);
        programName = new JTextField(20);
        //programName.setFont(new Font("Courier", Font.BOLD, 24));
        programName.setEditable(false);
//        add(programName);
        add(Box.createHorizontalGlue());
        add(loadButton);
        add(cycleButton);
        add(resetPSWButton);
        add(reloadButton);
        add(setStopButton);
        add(goToStopButton);
        add(clearStopButton);
        add(Box.createHorizontalGlue());
        
    }

    public void paintComponent(Graphics page)
    {
        super.paintComponent(page);
    }
    private class CycleButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
            cpu.cycle();
            pswp.repaintPSW();
            mp.repaintMemory();
            rp.repaintRegisters();
        }
    }
    private class LoadButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
          programName.setText("Reload Program");  
          JFileChooser chooser = new JFileChooser();
          String fname = Runner.getCodesPath();
          try {
              String f1name = "c:\\codes\\pname.txt";
              Scanner scan = new Scanner(new File(f1name));
              fname = scan.next();
          }
          catch (FileNotFoundException ioe)
          {
              fname = "c:\\codes";
          }
//          if (fname.equals(""))
//          {
//              fname = "./codes";
//          }
          chooser.setCurrentDirectory(new File(fname));
          int status = chooser.showOpenDialog (null);
          if (status == JFileChooser.APPROVE_OPTION)
          {
              try {
                     File loadFile = chooser.getSelectedFile();
                     fName = loadFile.getCanonicalPath().trim();
                     programName.setText(fName);
                     cpu.load(fName);
                     resetPSWButton.setEnabled(true);
                     cycleButton.setEnabled(true);
                     reloadButton.setText("Reload " + fName);
                     reloadButton.setEnabled(true);
                     setStopButton.setEnabled(true);
              }
              catch (IOException excp) 
              { }
          }
          else
          {
              return;
          }
          cpu.getPSW().setInstructionAddress(0);           
          pswp.repaintPSW();            
          mp.repaintMemory();
          rp.repaintRegisters();            
        }
    }
    private class ReloadButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
           programName.setText(fName);
           cpu.load(fName);
           resetPSWButton.setEnabled(true);
           cycleButton.setEnabled(true);
           cpu.getPSW().setInstructionAddress(0);           
           pswp.repaintPSW();            
           mp.repaintMemory();
           cpu.getRegisters().randomize();
           rp.repaintRegisters();            
           
        }
    }
    private class ResetPSWButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
            cpu.getPSW().setInstructionAddress(0);
            cpu.reset();
            pswp.repaintPSW();
            mp.repaintMemory();
            rp.repaintRegisters();
        }
    }
     private class SetStopButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
           stopSet = true;
           stopAddress = JOptionPane.showInputDialog("Stop address (hexadecimal):");
           goToStopButton.setEnabled(true);
           clearStopButton.setEnabled(true);
        }
    }  
     private class ClearStopButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
           stopSet = false;
           goToStopButton.setEnabled(false);
           clearStopButton.setEnabled(false);
    
        }
    }      
     private class GoToStopButtonListener implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
            if (stopSet)
            {
               PSW psw = cpu.getPSW();
               int currentAddress = psw.fetchInstructionAddress();
               int stopAddressInt = Integer.parseInt(stopAddress,16);
               while (stopAddressInt != currentAddress)
               {
                  cpu.cycle();
                  pswp.repaintPSW();
                  mp.repaintMemory();
                  rp.repaintRegisters();
                  currentAddress = psw.fetchInstructionAddress();
               }
            }
        }
    }       
}
