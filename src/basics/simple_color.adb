with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses_Constants;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Ada.Text_IO; 
procedure Simple_Color is
   package CC renames Terminal_Interface.Curses_Constants;
   
   procedure Print_In_Middle (Start_Y : in Line_Position := 0; 
                              Start_X : in Column_Position := 0;
                              Width_In : in Natural := 0;
                              S : String;
                              W: in Window := Standard_Window) is
      Window_X, X : Column_Count;
      Window_Y, Y : Line_Count;
      Width : Natural := Width_In;      -- In parameters are constants.
      
   begin
      Get_Size (Number_Of_Lines => Window_Y, Number_Of_Columns => Window_X);
      if Start_X /= 0 then 
         X := Start_X;
      else 
         X := Window_X;
      end if;
      if Start_Y /= 0 then 
         Y := Start_Y;
      else 
         Y := Window_Y;
      end if;
      if Width_In /= 0 then 
         Width := 80;
      else 
         Width := Integer (Window_X);
      end if;
      X := Start_X + Column_Position (Width - S'Length) / 2;
      Move_Cursor (W, Y, X);
      Put (S);
      Refresh;
   end Print_In_Middle;

   Red_On_Black : constant Color_Pair := 1;
   Key : Real_Key_Code;
begin
   Init_Screen;
   if not Has_Colors then 
      End_Screen;
      Ada.Text_IO.Put_Line ("Your terminal does not support color");
      return;
   end if;
   
   Start_Color;
   Init_Pair (Red_On_Black, CC.COLOR_RED, CC.COLOR_BLACK);
   
   Set_Character_Attributes (Color => Red_On_Black);
   Print_In_Middle (Lines / 2, 0, 0, "Viola !!! In color ...");
   Key := Get_Keystroke;
   Set_Character_Attributes;            --  Defaults to normal video and color pair zero.
   End_Screen;
end Simple_Color;
