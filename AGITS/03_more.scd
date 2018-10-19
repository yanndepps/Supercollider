// More about the language
// Objects, classes, messages, arguments
// The basic structure is Receiver.message(arguments) : receiver notation
[1, 2, 3, "wow"].reverse;
"hello".dup(4);
3.1415.round(0.1);
100.rand;
100.0.rand.round(0.01).dup(4);

// Receiver notation, functional notation
5.dup(20);  // receiver notation
dup(5, 20); // functional notation
3.1415.round(0.1);  // rn
round(3.1415, 0.1); // fn
// In short: Receiver.message(argument) is equivalent to message(Receiver, argument)
// Classes are almost always written as Receiver.message(arguments).

[1, 2, 3, 4, "hello"].scramble;
[1, 2, 3, 4, "hello"].mirror;
[1, 2, 3, 4].reverse + 10;

// convert midi to frequency in Hz
[60, 62, 64, 65, 67, 69, 71].midicps.round(0.1);

// Summary of all possible enclosures
// Collections [list, of, items]
// Functions { often multiple lines of code }
// Strings " words inside quotes "
// Symbols 'singlequotes' or preceded by a \backslash

// Functions
// a box through which data flows. the function operates on the data in some way,
// and the result is what flows out.
f = { 2 + 2 };
f.value;

// normally we'll want to define functions that give different results depending
// on the input arguments given.
// use the keyword arg to specify the inputs that a function can accept
f = {arg a, b; ["a plus b", a+b, "a times b", a*b].postln};
f.value(3, 7);
f.value(10, 14);

// compare:
~sillyRand = rrand(0, 10);
~sillyRand.value;
~sillyRand2 = {rrand(0, 10)};
~sillyRand2.value;

// how to spend summer days :
(
~whatToDo = {
	var today, dayName, actions;
	today = Date.getDate.dayOfWeek;
	dayName =
	case
	{today==0} {"sunday"}
	{today==1} {"monday"}
	{today==2} {"tuesday"}
	{today==3} {"wednesday"}
	{today==4} {"thursday"}
	{today==5} {"friday"}
	{today==6} {"saturday"};
	actions = ["boomerang throwing", "arm wrestling", "stair climbing", "playing chess", "underwater hockey", "pea shooting", "a nap marathon"];
	"ah, " ++ dayName ++ "...!" ++ " what a good day for " ++ actions.choose;
};
)

// run it in the morning
~whatToDo.value;

// TIP: another common notation to declare arguments at the beginning of a Function :
// f = {|a, b| a + b}
// equivalent to
// f = {arg a, b; a + b}

// Fun with Arrays
// Arrays are the most common type of collections in SC.
// Every time we write a collection of items between square brackets, like [0, 1, 2],
// it is an instance of the class Array.
// Here is a small selection of methods that arrays understand :
// Create some array
a = [10, 11, 12, 13, 14, 15, 16, 17];
a.reverse;    // reverse
a.scramble;   // scramble
a.choose;     // picks one element at random
a.size;       // returns size of array
a.at(0);      // retrieves item at specified position
a[0];         // same as above
a.wrapAt(10); // retrieves item at specified position, wrapping around if > a.size
["wow", 99] ++ a; // concatenates the two arrays into a new one
a ++ \hi;     // a symbol is a single character
a ++ 'hi';    // same as above
a ++ "hi";    // a string is a collection of characters
a.add(44);    // creates new array with new element at the end
a.insert(5, "wow"); // inserts "wow" at position 5, pushes other items forward, returns a new array
a;            // none of the above operations changed the original array
a.put(2, "oops"); // put "oops" at index 2 (destructive)
a.permute(3); // item at position 3 moves to position 1 and vice-versa
a.mirror;     // make it a palindrome
a.powerset;   // returns all possible combinations of the array's elements

// Math with arrays :
[1, 2, 3, 4, 5] + 10;
([1, 2, 3, 4, 5] / 7).round(0.01);
x = 11; y = 12;
[x, y, 9] * 100;

// Creating new Arrays
