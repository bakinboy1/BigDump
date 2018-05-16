/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package csu.datastructures.lab3;

/**
 *
 * @author csu
 */
public interface Assignment3Store 
{
    public void enqueueDevice(Device dev);
    public Device dequeueAnyDevice();
    public Device dequeuePeach();
    public Device dequeueCyborg();
    
}
