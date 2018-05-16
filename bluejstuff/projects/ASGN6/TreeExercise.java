/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.*;

/**
 *
 * @author csu
 */
public class TreeExercise
{

    public static void main(String args[])
    {

        String [] myStringsChars= new String[26];
        for(int i = 0; i < 26; i++)
        {
            myStringsChars[i] = new String(Character.toChars(i+65));
            System.out.println(myStringsChars[i]);

        }
        List<TreeNode> BinaryTree = new LinkedList();

        TreeNode alphabet;
        int j=0;
        while (j<myStringsChars.length){

            BinaryTree.add(alphabet = new TreeNode(myStringsChars[j]));
            if (j<=25){
                j++;
            }
        }
        BinaryTree.get(0).setParent(null);
        int k =0;

        while (k<BinaryTree.size()){
            int find=(k-1)/2;
            BinaryTree.get(k).setParent(BinaryTree.get(find));

            if(k%2 ==0){
                (BinaryTree.get(k).getParent()). setRightChild(BinaryTree.get(k));
            }
            else{
                (BinaryTree.get(k).getParent()).setLeftChild(BinaryTree.get(k));
            }
            k++;
        }
        TreeNode root=BinaryTree.get(0);

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
                
                System.out.println("Result is: " + "D");
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
    //create binary tree from array
    public static void createTree(String[] arr, TreeNode root){
        for (int i=1; i< arr.length; i++){
            int pr = (i-1)/2;
            TreeNode parent = root.findNodeOnTree(arr[pr].charAt(0));
            TreeNode newNode = new TreeNode( arr[i].charAt(0), parent);
            newNode.setLevel((int)(Math.log(i+1)/Math.log(2)));
            if (i%2!=0){
                parent.setLeftChild(newNode);
            }
            else{
                parent.setRightChild(newNode);
            }
        }
    }
    // One way of implementing this method is to store the paths from the nodes to 
    //the root in two array lists and then compare the two lists to each other to find
    //the first common ancestor. Another way is as follows
    public static TreeNode findLowestCommonAncestor(TreeNode node1, TreeNode node2)

    {

        // Given two nodes on the same tree, this method should return the lowest common ancestor.

        // if no common ancestor is found, this method returns null .      

        while(!node1.getParent().getContents().equals(node2.getParent().getContents())){

            if(node1.getLevel()>node2.getLevel()){

                node1 = node1.getParent();

            }else{

                node2 = node2.getParent();

            }

        }

        return node1.getParent();

    }
    //One way to implement levelOrderTraversal is as follows
    public static void levelOrderTraversal(TreeNode root) { 

        Queue<TreeNode> queue=new LinkedList<TreeNode>(); 

        queue.add(root); 

        while(!queue.isEmpty()) { 

            TreeNode tempNode=queue.poll(); 

            System.out.printf(tempNode.getContents()+ " "); 

            if(tempNode.getLeftChild()!=null)  {

                queue.add(tempNode.getLeftChild()); 

            }

            if(tempNode.getRightChild()!=null)  {

                queue.add(tempNode.getRightChild()); 

            }

        } 

        System.out.println("");

    }
    public static TreeNode findLowestCommonAncestor(TreeNode root, TreeNode node1, TreeNode node2)
    {
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
