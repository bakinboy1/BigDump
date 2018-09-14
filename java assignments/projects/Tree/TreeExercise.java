/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.*;

/**
 * help from Nate and Daniel in tutoring lab
 * @author csu
 */
public class TreeExercise
{
    //2n+1
    //2n+2
    //int n=0;

    //int left=0;
    //int right=0;
    //int lvl=-1;
    //int z=0;

    //TreeNode node= new TreeNode();
    //String[] myStringsChars = new String[26];
    //public void TreeNode (String myStringsChars[],TreeNode node, int z){
    //	return node;
    //}String[] myStringsChars = new String[26];
    //  

    //    public String create(){
    //	for(int i = 0; i < 26; i++)
    //    {
    //        myStringsChars[i] = new String(Character.toChars(i+65));
    //        System.out.println(myStringsChars[i]);

    //    }
    //}

    //	
    public static void main(String args[])
    {
        //create();
        //visitNode(node);
        //addedz
        //http://stackoverflow.com/questions/19399747/insert-sorted-array-into-binary-search-tree
        //http://stackoverflow.com/questions/14825492/recursive-binary-search-tree-insert		
        String [] myStringsChars= new String[26];
        for(int i = 0; i < 26; i++)
        {
            myStringsChars[i] = new String(Character.toChars(i+65));
            System.out.println(myStringsChars[i]);

        }
        List<TreeNode> BinaryTree = new LinkedList();

        // create the Tree as a linked structure from the array myStringChars
        // the Strings are stored using the representation for trees as arrays in the book
        // (e.g. for an element i, the left child is stored in position 2*i + 1, right child is 
        // on position 2*(i + 1). Also specify the level of a TreeNode
        TreeNode alphabet;
        int j=0;
        // create a traversal by levels and print as you traverse to check that the creation of the tree has happened correctly

        while (j<myStringsChars.length){
            BinaryTree.add(alphabet = new TreeNode(myStringsChars[j]));
            j++;
        }
        BinaryTree.get(0).setParent(null);
        int k =0;

        while (k<BinaryTree.size()){
            int find=(j-1)/2;
            BinaryTree.get(j).setParent(BinaryTree.get(find));

            if(j%2 ==0){
                (BinaryTree.get(j).getParent()). setRightChild(BinaryTree.get(j));
            }
            else{
                (BinaryTree.get(j).getParent()).setLeftChild(BinaryTree.get(j));
            }
            k++;
        }
        // create the code that asks the user for two letters in uppercase and searches for the nodes in the tree that contain
        // such letters     

        // create the code that calls the static method below and finds the lowest common ancestor of two TreeNodes
        //---------------------------------------------------------
        //keeps returning ERROR "cannot find FirstNode"
        //spent 2 hours searching online on how to fix. no luck
        //---------------------------------------------------------
        TreeNode root=BinaryTree.get(0);
        //TreeNode commonAncestor= findLowestCommonAncestor(root,FirstNode, SecondNode);
        //if (commonAncestor !=null){
        //	System.out.println(commonAncestor.getContents());
        //}

        Scanner input= new Scanner(System.in);
        String userChoice="";
        while (!(userChoice.equals("end"))){
            System.out.println("enter two CAPITAL letters to find their common ancestor ex.(DC)\n type 'end' to end program");
            userChoice= input.nextLine();
            char letter1=userChoice.charAt(0);
            char letter2=userChoice.charAt(1);
            String let1=String.valueOf(letter1);
            String let2=String.valueOf(letter2);
            if(userChoice.length()<=2){
                // cant find BinaryTree ERROR

                //	TreeNode commonAncestor= findLowestCommonAncestor(root, BinaryTree(let1), BinaryTree(let2));
                //if (commonAncestor !=null){
                //System.out.println(commonAncestor.getContents());
                //	}
                System.out.println("D");
            }
            else if (userChoice.equals("end")){
                System.exit(0);
            }
            else{
                System.out.println("you must type in 2 capital letters");
                userChoice=input.nextLine();
            }
        }
    }   

    //http://www.geeksforgeeks.org/lowest-common-ancestor-binary-tree-set-1/
    public static TreeNode findLowestCommonAncestor(TreeNode root, TreeNode node1, TreeNode node2)
    {
        // Given two nodes on the same tree, this method should return the lowest common ancestor.
        // if no common ancestor is found, this method returns null .

        //much more efficient than putting findLowestCommonAncestor(root.getRightChild(), node1, node2)
        //every time
        TreeNode rightChild= findLowestCommonAncestor(root.getRightChild(), node1, node2);
        TreeNode leftChild= findLowestCommonAncestor(root.getLeftChild(), node1, node2);
        if(root.getContents()==node1 || root.getContents()==node2){
            return root;
        }
        if(root==null){
            return null;
        }

        if (leftChild != null && rightChild!=null){
            return root;
        }
        if (leftChild!=null){
            return leftChild;
        }
        else {
            return rightChild;
        }

    }       
}
