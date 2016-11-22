#!/usr/bin/python
# -*- coding: utf-8 -*-
import random
from emoji.code import emojiCodeDict
emojis = emojiCodeDict.values()
n = random.randint(0, len(emojis) - 1)
print emojis[n].encode('utf-8')
