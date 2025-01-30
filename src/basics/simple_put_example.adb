with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Terminal_Interface.Curses.Text_IO.Integer_IO; 
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
procedure Simple_Put_Example is 
   package Integer_IO is new 
     Terminal_Interface.Curses.Text_IO.Integer_IO (Integer); 
   use Integer_IO;
   -- Rather than instantiate a new package for both Line_Position
   -- and Column_Position, just instantiate one for Integer and do an 
   -- explicit cast to Integer for output.

   Message : String := "Just a string"; -- Message to display on screen.
   Columns : Column_Count;              -- To store number of columns on screen.
   Lines : Line_Count;                  -- To store number of rows on screen.
   Key : Real_Key_Code;
begin
   Init_Screen;                         -- Start curses mode.
   -- Get the number of rows and columns on the screen.
   Get_Size (Number_Of_Lines => Lines, Number_Of_Columns => Columns);
   -- Print the message at the center of the screen.
   Move_Cursor (Line => Lines / 2, Column => (Columns - Message'Length) / 2);
   Put (Message);
   Move_Cursor (Line => Lines - 2, Column => 0);
   Put ("This screen has ");
   Put (Integer (Lines), 0);
   Put (" rows and ");
   Put (Integer (Columns), 0);
   Put_Line (" columns");
   Put ("Try resizing your window (if possible) and then run this program again");
   Refresh;
   Key := Get_Keystroke;
   End_Screen;
end Simple_Put_Example;
