
import java.util.*;

public class TreeExercise 
{
    public static void main(String args[])
    {
        String[] myStringChars = new String[26];

        for(int i = 0; i < 26; i++)
        {
            myStringChars[i] = new String(Character.toChars(i+65));
            System.out.println(myStringChars[i]);
        }

        LinkedList<TreeNode> tree = new LinkedList<TreeNode>();

        for (int i = 0; i < myStringChars.length; i++)
        {
            TreeNode rootTree = new TreeNode(myStringChars[i], null);
            tree.add(i, rootTree);
        }
        for (int i = 1; i < tree.size(); i++)
        {
            if (i % 2 == 0)
            {
                tree.get(i).setParent(tree.get((((i - 2) / 2))));
                tree.get(((i - 2) / 2)).setRightChild(tree.get(i));
            }
            else
            {
                tree.get(i).setParent(tree.get(i / 2));
                tree.get(i / 2).setLeftChild(tree.get(i));
            }
        }
        TreeNode firstNode = new TreeNode();
        TreeNode secondNode = new TreeNode();

        while(true)
        {
            Scanner input = new Scanner(System.in);
            System.out.println("What letter do you want to find? ");

            String in = input.nextLine();
              
            while(in.length() != 2){
                
                System.out.println(" you must type 2 capital letters as input \n ");
                in = input.nextLine();
            }

            char first= in.charAt(0);
            char second=in.charAt(1);

            String firstInput = String.valueOf(first);
            firstInput=firstInput.toUpperCase();
            firstNode.setContents(firstInput);

            String secondInput = String.valueOf(second);
            secondInput = secondInput.toUpperCase();
            secondNode.setContents(secondInput);

            for (int i = 0; i < tree.size(); i++)
            {

                if (firstInput.equals(tree.get(i).getContents()))
                {
                    firstNode = tree.get(i);

                }
                if (secondInput.equals(tree.get(i).getContents()))
                {
                    secondNode = tree.get(i);

                }

            }
            TreeNode commonAncestor = findLowestCommonAncestor(firstNode, secondNode);
            if(commonAncestor != null){
                System.out.println("the root is: " +commonAncestor.getContents());

            }  

        }

    }

    public static TreeNode findLowestCommonAncestor(TreeNode node1, TreeNode node2)
    {
        // Given two nodes on the same tree, this method should return the lowest common ancestor.
        // if no common ancestor is found, this method returns null .
        LinkedList<TreeNode> tree1 = new LinkedList<TreeNode>(); 
        LinkedList<TreeNode> tree2 = new LinkedList<TreeNode>();
        tree1.add(0, node1);
        tree2.add(0, node2);
        int count = 0;
        while (node1.getParent() != null)
        {
            count++;
            tree1.add(count, node1.getParent());
            node1 = node1.getParent();
        }
        count = 0;
        while (node2.getParent() != null)
        {
            count++;
            tree2.add(count, node2.getParent());
            node2 = node2.getParent();
        }
        for (int i = 0; i < tree1.size(); i++)
        {
            for (int j = 0; j < tree2.size(); j++)
            {
                if (tree1.get(i).getContents().equals(tree2.get(j).getContents()))
                {
                    return tree1.get(i);
                }
            }
        }
        return null;
    }       
}
