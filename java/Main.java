/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;

import java.util.*;

public class Main {

    public static void main(String[] args) {
       ArrayList<Author> author= new ArrayList<Author>();
        Author a = new Author("Ray", "Charles");
        Author e = new Author("Sentient", "Dog");
        Author c = new Author("speed", "wagon");
        Author d = new Author("kermit", "the frog");
        Author f = new Author("Steven", "Hawking");


        Book b = new Book(a, "object OD", 20102);

        System.out.println(b.getAuthorName());
        System.out.println(b.getTitle());

        //Get a specific book from shelf
        //Add a single book to shelf
        //Add multiple books to the shelf
        //View the books on the shelf   (Title, author, publish year)
        ArrayList<Book> shelf = new ArrayList<Book>();
        shelf.add(new Book(e, "the framework and logistics of taco dueling", 1880));
        shelf.add(new Book(a, "how to read", 1401));
        shelf.add(new Book(c, "The philisophical underpinnings of wet sand", 1920));
        shelf.add(new Book(d, "Homeless Cooking", 1501));
        shelf.add(new Book(f, "Parkour-101", 2018));

        System.out.println(shelf);
        Bookshelf call = new Bookshelf();
        System.out.println(call.getBook("Homeless Cooking"));
    }
   
}
