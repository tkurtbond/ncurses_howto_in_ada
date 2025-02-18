with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;

procedure Acs_Vars is
   procedure Print (A: ACS_Index) is
      Ch : Attributed_Character := ACS_Map (A);
   begin
      Add (Ch => Ch);
   end Print;
   Key : Real_Key_Code;
begin
   Init_Screen;

   Put ("Upper left corner           "); Print (ACS_Upper_Left_Corner);  New_Line;
   Put ("Lower left corner           "); Print (ACS_Lower_Left_Corner);  New_Line;
   Put ("Lower right corner          "); Print (ACS_Lower_Right_Corner); New_Line;
   Put ("Tee pointing right          "); Print (ACS_Left_Tee);           New_Line;
   Put ("Tee pointing left           "); Print (ACS_Right_Tee);          New_Line;
   Put ("Tee pointing up             "); Print (ACS_Bottom_Tee);         New_Line;
   Put ("Tee pointing down           "); Print (ACS_Top_Tee);            New_Line;
   Put ("Horizontal line             "); Print (ACS_Horizontal_Line);    New_Line;
   Put ("Vertical line               "); Print (ACS_Vertical_Line);      New_Line;
   Put ("Large Plus or cross over    "); Print (ACS_Plus_Symbol);        New_Line;
   Put ("Scan Line 1                 "); Print (ACS_Scan_Line_1);        New_Line;
   Put ("Scan Line 3                 "); Print (ACS_Scan_Line_3);        New_Line;
   Put ("Scan Line 7                 "); Print (ACS_Scan_Line_7);        New_Line;
   Put ("Scan Line 9                 "); Print (ACS_Scan_Line_9);        New_Line;
   Put ("Diamond                     "); Print (ACS_Diamond);            New_Line;
   Put ("Checker board (stipple)     "); Print (ACS_Checker_Board);      New_Line;
   Put ("Degree Symbol               "); Print (ACS_Degree);             New_Line;
   Put ("Plus/Minus Symbol           "); Print (ACS_Plus_Minus);         New_Line;
   Put ("Bullet                      "); Print (ACS_Bullet);             New_Line;
   Put ("Arrow Pointing Left         "); Print (ACS_Left_Arrow);         New_Line;
   Put ("Arrow Pointing Right        "); Print (ACS_Right_arrow);        New_Line;
   Put ("Arrow Pointing Down         "); Print (ACS_Down_Arrow);         New_Line;
   Put ("Arrow Pointing Up           "); Print (ACS_Up_Arrow);           New_Line;
   Put ("Board of squares            "); Print (ACS_Board_Of_Squares);   New_Line;
   Put ("Lantern Symbol              "); Print (ACS_Lantern);            New_Line;
   Put ("Solid Square Block          "); Print (ACS_Solid_Block);        New_Line;
   Put ("Less/Equal sign             "); Print (ACS_Less_Or_Equal);      New_Line;
   Put ("Greater/Equal sign          "); Print (ACS_Greater_Or_Equal);   New_Line;
   Put ("Pi                          "); Print (ACS_PI);                 New_Line;
   Put ("Not equal                   "); Print (ACS_Not_Equal);          New_Line;
   Put ("UK pound sign               "); Print (ACS_Sterling);           New_Line;

   Refresh;
   Key := Get_Keystroke;   -- Wait for a keystroke, so it can be seen.
   End_Screen;
end Acs_Vars;
