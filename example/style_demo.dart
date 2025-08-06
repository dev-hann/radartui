import 'package:radartui/radartui.dart';

void main() {
  runApp(const StyleDemoApp());
}

class StyleDemoApp extends StatelessWidget {
  const StyleDemoApp();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Container(
          width: 60,
          height: 3,
          color: Color.blue,
          child: Center(
            child: Text(
              '🎨 RadarTUI Style Demo 🎨',
              style: TextStyle(
                color: Color.brightWhite,
                bold: true,
              ),
            ),
          ),
        ),
        
        SizedBox(height: 1),
        
        // Basic colors
        Text(
          'Basic Colors:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        Row(children: [
          Text('Red: ', style: TextStyle(color: Color.red, bold: true)),
          Text('Green: ', style: TextStyle(color: Color.green, bold: true)),
          Text('Blue: ', style: TextStyle(color: Color.blue, bold: true)),
          Text('Yellow: ', style: TextStyle(color: Color.yellow, bold: true)),
        ]),
        
        SizedBox(height: 1),
        
        // Background colors
        Text(
          'Background Colors:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        Row(children: [
          Container(
            color: Color.red,
            child: Text(' RED BG ', style: TextStyle(color: Color.white)),
          ),
          SizedBox(width: 2),
          Container(
            color: Color.green,
            child: Text(' GREEN BG ', style: TextStyle(color: Color.black)),
          ),
          SizedBox(width: 2),
          Container(
            color: Color.blue,
            child: Text(' BLUE BG ', style: TextStyle(color: Color.white)),
          ),
        ]),
        
        SizedBox(height: 1),
        
        // Text styles
        Text(
          'Text Styles:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        Column(children: [
          Text('Bold Text', style: TextStyle(bold: true)),
          Text('Italic Text', style: TextStyle(italic: true)),
          Text('Underlined Text', style: TextStyle(underline: true)),
          Text(
            'Combined Styles',
            style: TextStyle(
              bold: true,
              italic: true,
              underline: true,
              color: Color.magenta,
            ),
          ),
        ]),
        
        SizedBox(height: 1),
        
        // Container demo
        Text(
          'Container with Padding & Margin:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(h: 4, v: 1),
          color: Color.cyan,
          child: Text(
            'This is inside a styled container!',
            style: TextStyle(color: Color.black, bold: true),
          ),
        ),
        
        SizedBox(height: 1),
        
        Text(
          'Press any key to see the counter increment →',
          style: TextStyle(
            color: Color.brightYellow,
            italic: true,
          ),
        ),
      ],
    );
  }
}