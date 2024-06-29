const counterSample = '''
<stack>

  <script>
  var counter = 0
  fun add() {
      counter++
  }
  </script>
  
  <color>#fefefe</color>
  
  <column mainAxisAlignment="spaceBetween">

    <box height='48' color='#ffffff' shadows='#22000000 16 0 0'>
      <text size='18'>Counter</text>
    </box>

    <animation duration='100'>
      <text  :content="counter" size='24'></text>
    </animation>
    
    <row mainAxisAlignment='end'>
      <padding all='32'>
        <button onTap='add()'>
          <box
          color='#aaeeaa' 
          width='48' height='48' 
          shape='circle' shadows='#22000000 16 0 8'>
            <text size='24'>+</text>
          </box>
        </button>
      </padding>
    </row>
    
  </column> 
    
</stack>

''';
