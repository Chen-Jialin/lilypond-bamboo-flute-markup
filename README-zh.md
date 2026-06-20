# lilypond-bamboo-flute-markup

> [English version / 英文版本](README.md)

为 LilyPond 乐谱自动标注竹笛的指法、气息和简谱。

## 它是做什么的

给定一份 LilyPond 乐谱（如 `testcase.ly`），脚本会生成两种带标注的输出：

| 输出 | 用途 | 内容 |
|---|---|---|
| `testcase-practice.ly` | 练习 | 指法图 + 简谱 + 音名数字——每个音符上方都有标注，适合自学 |
| `testcase-perform.ly` | 演奏 | 仅简谱——干净整洁，适合上台或排练使用 |

## 用法

### 依赖

- Python 3
- [LilyPond](https://lilypond.org/) 2.24（须在 PATH 中）

### 一键运行

```bash
python bamboo_flute_markup.py
```

这会自动完成六步流水线：编译输入 → 生成标注 → 生成两个输出文件 → 分别编译为 PDF。任意步骤失败会立即停止。

### 单独编译

```bash
lilypond testcase.ly             # 编译原始输入
lilypond testcase-practice.ly    # 编译练习谱
lilypond testcase-perform.ly     # 编译演奏谱
```

## 如何准备输入文件

1. 编写一份标准的 LilyPond `.ly` 文件（支持 `\fixed c'`、`\relative` 和绝对模式）
2. 在旋律中用 `% score begin` 和 `% score end` 标记需要标注的音符范围
3. 如需歌词，可添加一个 `lyric = \lyricmode{...}` 变量块（可选）
4. 可附加一个含 `\midi { }` 的 `\score` 块用于 MIDI 输出，生成时会被自动移除

简要示例：

```lilypond
\version "2.24.3"
\language english

#(set-global-staff-size 26)

melody = \fixed c' {
  \clef treble
  \key c \major
  \time 4/4

  % score begin
  c4 d e f | g2 c
  % score end
}

\score {
  \new Staff \melody
  \layout { }
}
```

## 项目结构

| 文件 | 角色 |
|---|---|
| `bamboo_flute_markup.py` | 核心脚本——读取 `.ly`、生成标注、输出两个文件 |
| `testcase.ly` | 输入——手工编写的 LilyPond 乐谱 |
| `testcase-practice.ly` | 输出——练习谱（指法 + 简谱 + 音名数字） |
| `testcase-perform.ly` | 输出——演奏谱（仅简谱，干净） |

## 实现原理

脚本使用正则表达式（而非完整的 LilyPond 解析器）来匹配和替换音符。核心流程：

1. 识别调号（`\key`）和八度模式（`\fixed` / `\relative` / 绝对模式）
2. 展开 LilyPond 的省略记谱（`c'4 b b8` → `c'4 b4 b8`）
3. 将所有音符统一为绝对八度模式，便于一致性处理
4. 两轮 `re.sub` 遍历：
   - 给每个音符附加 `\woodwind-diagram` 指法图和 `+` 吹气强度记号
   - 将每个音符转换为简谱数字 `\markup{...}`
5. 将标注内容替换入原谱，插入简谱变量块，移除 MIDI `\score`，并编译

音符到指法的映射基于：**调性**（如 C / G / F 调）→ 竹笛最低音的 MIDI 编号 → 音高差 → 查指法表。

## 许可

见 LICENSE 文件。