
    /**
     * Write a description of class logSort here.
     * 
     * @author (your name) 
     * @version (a version number or a date)
     */
    public  class logSort 
    {
        public static <T extends Comparable <T>> void quickSort (T [] data){
            
            quickSort(data, 0, data.length-1);
            
        }
        
        private static <T extends Comparable <T>> void quickSort(T [] data, int min, int max){
            
            if (min < max)
            {
                int indexOfPartition = partition (data, min, max);
                
                quickSort(data, min, indexOfPartition-1);
                
                quickSort(data, indexOfPartition+1, max);
            }
        }
        
        private static <T extends Comparable <T>> int partition (T [] data, int min, int max){
            
            T partitionElement;
            int left, right;
            int middle = (min + max)/2;    
            
            partitionElement = data [middle];
            
            swap (data, middle, min);
            
            left = min;
            right = max;
            
            while (left < right){
                
                while (left<right && data[left].compareTo(partitionElement)<=0){
                    left++;
                }
                while(data[right].compareTo(partitionElement)){
                    right--;
                }
                ///complete this part
           
                swap(data, left, right);
            }
            
            swap (data, min, right);
            
            return right;
            
        }
        
        private static <T> void swap (T [] data, int index1, int index2){
            // complete this method
            T temp=data[index1];
            data [index1]=data[index2];
            data [index2]= temp;
        }
        
        
            
    }