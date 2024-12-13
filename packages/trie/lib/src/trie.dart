class TrieNode {
  Map<String, TrieNode> children = {};
  bool isWord = false;
}

class Trie {
  TrieNode root;

  Trie({required this.root});

  insert(String word) {
    TrieNode currentNode = root;
    List<String> chars = word.split('');
    for (String char in chars) {
      if (!currentNode.children.containsKey(char)) currentNode.children[char] = TrieNode();
      currentNode = currentNode.children[char]!;
    }
    currentNode.isWord = true;
  }

  suggestHelper(TrieNode root, List<String> list, String current) {
    if (root.isWord) {
      list.add(current);
    }
    if (root.children.entries.isEmpty) {
      return;
    }
    for (String child in root.children.keys) {
      suggestHelper(root.children[child]!, list, current + child);
    }
  }

  List<String> suggest(String prefix) {
    TrieNode currentNode = root;
    String current = '';
    List<String> chars = prefix.split("");
    for (String char in chars) {
      if (!currentNode.children.containsKey(char)) {
        return [];
      }
      currentNode = currentNode.children[char]!;
      current += char;
    }
    List<String> list = [];
    suggestHelper(currentNode, list, current);
    return list;
  }
}
