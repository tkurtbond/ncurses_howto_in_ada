with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Terminal_Interface.Curses.Text_IO.Integer_IO; 
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
procedure Simple_Put_Example is 
   package Integer_IO is new 
     Terminal_Interface.Curses.Text_IO.Integer_IO (Integer); 
   use Integer_IO;

   Message : String := "Just a string";
   Columns : Column_Count;
   Lines : Line_Count;
   Key : Real_Key_Code;
begin
   Init_Screen;
   Get_Size (Number_Of_Lines => Lines, Number_Of_Columns => Columns);
   Move_Cursor (Line => Lines / 2, Column => (Columns - Message'Length) / 2);
   Put (Message);
   Move_Cursor (Line => Lines - 2, Column => 0);
   Put ("This screeen has ");
   Put (Integer (Lines), 0);
   Put (" rows and ");
   Put (Integer (Columns), 0);
   Put_Line (" columns");
   Put ("Try resizing your window (if possible) and then run this program again");
   Refresh;
   Key := Get_Keystroke;
   End_Screen;
end Simple_Put_Example;
