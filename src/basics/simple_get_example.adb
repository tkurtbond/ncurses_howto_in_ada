with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Simple_Get_Example is 
   Message : String := "Enter a string: "; -- Message to display on screen.
   User_Input : String(1..80) := (others => ' ');
   Num_Lines : Line_Count;      -- To store number of rows/lines on screen.
   Num_Columns : Column_Count; -- To store number of columns on screen.
   Key : Real_Key_Code;
begin
   Init_Screen;                         -- Start curses mode.
   Num_Lines := Lines;       -- Get the number of lines on the screen.
   Num_Columns := Columns;   -- Get the number of columns on the screen.
   Move_Cursor (Line => Num_Lines / 2, 
                Column => (Num_Columns - Message'Length) / 2);
   Put (Message);
   Get (Str => User_Input);
   Move_Cursor (Line => Num_Lines - 2, Column => 0);
   Put ("You Entered: " & Trim (User_Input, Right));
   Key := Get_Keystroke;
   End_Screen;
end Simple_Get_Example;
