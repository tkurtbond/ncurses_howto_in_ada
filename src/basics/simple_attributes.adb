with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
procedure Simple_Attributes is 
   package ATIO renames Ada.Text_IO;
   Input_File : File_Type;
   Input_Stream : Stream_Access;
   Lines : Line_Count; 
   Columns : Column_Count;
   Line : Line_Position;
   Column : Column_Position;
   Ch : Character;
   Prev : Character := Ada.Characters.Latin_1.NUL;
   Key : Real_Key_Code;
begin
   if Argument_Count /= 1 then 
      ATIO.Put ("Usage: " & Command_Name & "A-C-FILE-NAME");
      Set_Exit_Status (Failure); 
   end if;
   Open (Input_File, In_File, Argument (1)); 
   -- Errors will exit the program with a message.
   
   Input_Stream := Stream (Input_File);
   
   Init_Screen;                         -- Start curses mode.
   Get_Size (Number_Of_Lines => Lines, Number_Of_Columns => Columns);
   -- Find the boundaries of the screen.
   
   while not End_Of_File (Input_File) loop -- Read the file until we reach the end.
      Character'Read (Input_Stream, Ch);
      Get_Cursor_Position (Line => Line, Column => Column); 
      -- Get the current cursor position.
      
      if Line = (Lines - 1) then        -- Are we at the end of the screen?
         Put ("<-Press Any Key->");     -- Tell the user to press a key.
         Key := Get_Keystroke;
         Clear;                         -- Clear the screen.
         Move_Cursor (Line => 0, Column => 0);
      end if;
      
      if Prev = '/' and Ch = '*' then   -- If it is / and * then only switch bold on.
         Switch_Character_Attribute 
           (Attr => (Bold_Character => True, others => False),
            On => True);
         Get_Cursor_Position (Line => Line, Column => Column);
         Move_Cursor (Line => Line, Column => Column - 1);
         Put ('/');
         Put (Ch);
      else
         Put (Ch);
      end if;
      
      Refresh;
      if Prev = '*' and Ch = '/' then
         Switch_Character_Attribute
           (Attr => (Bold_Character => True, others => False),
            On => False);
      end if;
      
      Prev := Ch;
   end loop;
   End_Screen;
end Simple_Attributes;
