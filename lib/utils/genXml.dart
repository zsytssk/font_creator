class XMLItem {
  int id;
  int x;
  int y;
  int width;
  int height;
  XMLItem({this.id, this.x, this.y, this.width, this.height});
}

String genXml(
    {int fontSize, int spacing, int width, height, String fileName, items}) {
  final tpl = '''<?xml version="1.0"?>
<font>
  <info face="微软雅黑" size="$fontSize" bold="0" italic="0" charset="" unicode="1" stretchH="100" smooth="1" aa="1" padding="0,0,0,0" spacing="$spacing,$spacing" outline="0"/>
  <common lineHeight="$fontSize" base="26" scaleW="$width" scaleH="$height" pages="1" packed="0" alphaChnl="1" redChnl="0" greenChnl="0" blueChnl="0"/>
  <pages>
    <page id="0" file="$fileName.png" />
  </pages>
  <chars count="${items.length}">
{items}
  </chars>
</font>''';

  String items_str = '';
  for (int i = 0; i < items.length; i++) {
    final item = items[i];
    items_str +=
        '      <char id="${item.id}" x="${item.x}" y="${item.y}" width="${item.width - spacing}" height="${item.height - spacing}" xoffset="0" yoffset="0" xadvance="${item.width - spacing}" page="0" chnl="15" />';
    if (i != items.length - 1) {
      items_str += '\n';
    }
  }

  return tpl.replaceFirst('{items}', items_str);
}
