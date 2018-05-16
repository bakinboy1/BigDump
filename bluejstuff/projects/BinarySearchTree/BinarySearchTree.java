
/**
 * Write a description of class BinarySearchTree here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class BinarySearchTree
{
   
   private  Node root;
    
    public BinarySearchTree(){
        
        
    }
    
    public boolean find(int id){
        // your code goea here
        //temporary pointer
        Node temp=root;
        while(temp!= null){
            if(id==temp.data){
                return true;
            }
            else if (temp.data>id){
            temp=temp.left;
            }
            else {
            temp=temp.right;
            }
            
        }
        return false;
    }
    
    
    
    public void  insert(int id){
        //warp it in a node first
        Node newNode= new Node (id);
        Node temp=root;
        Node parent=null;
        
        if (root==null){
                root=newNode;
                return;
            }
        
        while (true){
            parent=temp;
            if (id<=temp.data){
                temp=temp.left;
                if(temp==null){
                   parent.left=newNode;
                   return;
                }
            }
            if (id>=temp.data){
                temp=temp.right;
                if(temp==null){
                   parent.right=newNode;
                   return;
                }
            }
        }

    }
    
    public void display(Node root){
        if(root!=null){
        display(root.left);
        System.out.print(" "+ root.data);
        display(root.right);
       }
        }
    
    
    public boolean delete(int id){
        Node parent = root;
        Node current = root;
        boolean isLeftChild = false;
        while(current.data!=id){
            parent = current;
            if(current.data>id){
                isLeftChild = true;
                current = current.left;
            }else{
                isLeftChild = false;
                current = current.right;
            }
            if(current ==null){
                return false;
            }
        }
        //if i am here that means we have found the node
        //Case 1: if node to be deleted has no children
        if(current.left==null && current.right==null){
            if(current==root){
                root = null;
            }
            if(isLeftChild ==true){
                parent.left = null;
            }else{
                parent.right = null;
            }
        }
        //Case 2 : if node to be deleted has only one child
        else if(current.right==null){
            if(current==root){
                root = current.left;
            }else if(isLeftChild){
                parent.left = current.left;
            }else{
                parent.right = current.left;
            }
        }
        else if(current.left==null){
            if(current==root){
                root = current.right;
            }else if(isLeftChild){
                parent.left = current.right;
            }else{
                parent.right = current.right;
            }
        }else if(current.left!=null && current.right!=null){
            
            //now we have found the minimum element in the right sub tree
            Node successor   = getSuccessor(current);
            if(current==root){
                root = successor;
            }else if(isLeftChild){
                parent.left = successor;
            }else{
                parent.right = successor;
            }           
            successor.left = current.left;
        }       
        return true;        
    }
    
    public Node getSuccessor(Node deleleNode){
        Node successsor =null;
        Node successsorParent =null;
        Node current = deleleNode.right;
        while(current!=null){
            successsorParent = successsor;
            successsor = current;
            current = current.left;
        }
        //check if successor has the right child, it cannot have left child for sure
        // if it does have the right child, add it to the left of successorParent.
        //      successsorParent
        if(successsor!=deleleNode.right){
            successsorParent.left = successsor.right;
            successsor.right = deleleNode.right;
        }
        return successsor;
    }
    
    
    public static void main(String arg[]){
        
    }
    
}

class Node{
    int data;
    Node left;
    Node right;
    public Node(int data){
        this.data=data;
        left=null;
        right=null;
    }

}
