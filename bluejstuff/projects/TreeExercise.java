/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author csu
 */
public class TreeExercise 
{
    public static void main(String args[])
    {
        String[] myStringsChars = new String[26];
        
        for(int i = 0; i < 26; i++)
        {
            myStringChars[i] = new String(Character.toChars(i+65));
            System.out.println(myStringChars[i]);
        }
        
        // create the Tree as a linked structure from the array myStringChars
        // the Strings are stored using the representation for trees as arrays in the book
        // (e.g. for an element i, the left child is stored in position 2*i + 1, right child is 
        // on position 2*(i + 1). Also specify the level of a TreeNode
        
        
        // create a traversal by levels and print as you traverse to check that the creation of the tree has happened correctly
        
        
        // create the code that asks the user for two letters in uppercase and searches for the nodes in the tree that contain
        // such letters     
                
        
        // create the code that calls the static method below and finds the lowest common ancestor of two TreeNodes
        TreeNode commonAncestor = findLowestCommonAncestor(firstNode, secondNode);
        
        if(commonAncestor != null)
        {
            System.out.println(commonAncestor.getContents());
        }    
    }   
    
    public static TreeNode findLowestCommonAncestor(TreeNode node1, TreeNode node2)
    {
        // Given two nodes on the same tree, this method should return the lowest common ancestor.
        // if no common ancestor is found, this method returns null .
    }       
}
