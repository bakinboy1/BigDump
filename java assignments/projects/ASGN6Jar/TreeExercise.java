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
    //  return node;
    //}String[] myStringsChars = new String[26];
    //  

    //    public String create(){
    //  for(int i = 0; i < 26; i++)
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

        String [] myStringsChars= new String[26];
        for(int i = 0; i < 26; i++)
        {
            myStringsChars[i] = new String(Character.toChars(i+'A'));
            System.out.println(myStringsChars[i]);

        }
        List<TreeNode> BinaryTree = new LinkedList();

        // create the Tree as a linked structure from the array myStringChars
        // the Strings are stored using the representation for trees as arrays in the book
        // (e.g. for an element i, the left child is stored in position 2*i + 1, right child is 
        // on position 2*(i + 1). Also specify the level of a TreeNode
        TreeNode alphabet;
        
        // create a traversal by levels and print as you traverse to check that the creation of the tree has happened correctly
        int j=0;
        while (j<myStringsChars.length){

            BinaryTree.add(alphabet = new TreeNode(myStringsChars[j]));
            if (j<=26){
                j++;
            }
        }
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
        BinaryTree.get(0).setParent(null);
        TreeNode root=(BinaryTree.get(0).getParent());
        // create the code that asks the user for two letters in uppercase and searches for the nodes in the tree that contain
        // such letters     

        // create the code that calls the static method below and finds the lowest common ancestor of two TreeNodes
        //---------------------------------------------------------
        //keeps returning ERROR "cannot find FirstNode"
        //spent 2 hours searching online on how to fix. no luck
        //---------------------------------------------------------
        
        //TreeNode commonAncestor= findLowestCommonAncestor(root,FirstNode, SecondNode);
        //if (commonAncestor !=null){
        //  System.out.println(commonAncestor.getContents());
        //}
        
        Scanner input= new Scanner(System.in);
        String userChoice="";
        while (!(userChoice.equals("end"))){
            System.out.println("enter two CAPITAL letters to find their common ancestor ex.(DC)\n type 'end' to end program");
            userChoice= input.nextLine();
            char letter1=userChoice.charAt(0);
            char letter2=userChoice.charAt(1);
            int let1= (int)letter1- 'A';
            int let2= (int)letter2- 'A';
            if(userChoice.length()<=2){
                // cant find BinaryTree ERROR

                TreeNode commonAncestor= findLowestCommonAncestor(root, BinaryTree.get(let1), BinaryTree.get(let2));
                if (commonAncestor !=null){
                    System.out.println(root);
                    }
                
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
        
        if(root==null){
            return null;
        }
        TreeNode rightChild= findLowestCommonAncestor(root.getRightChild(), node1, node2);
        TreeNode leftChild= findLowestCommonAncestor(root.getLeftChild(), node1, node2);
        if (leftChild!=null){
            return leftChild;
        }
        if (leftChild != null && rightChild!=null){
            return root;
        }
        

        
        
        if(root.getContents()==node1 || root.getContents()==node2){
            return root;
        }
        
        else {
            return rightChild;
        }

    }       
}
- least Common Ancestor function doesn't work correctly. Logic is not clear for that function. 

Overall Feedback:
- One way to create a binary tree from an array is as follows:

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

 

- One way of implementing this method is to store the paths from the nodes to the root in two array lists and then compare the two lists to each other to find the first common ancestor. Another way is as follows:

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

One way to implement levelOrderTraversal is as follows:

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
