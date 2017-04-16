#!/usr/bin/env python
# -*- coding: utf-8 -*-

import string
import xerox

rawData = (xerox.paste())
rawData = rawData.encode('utf-8')

Output = str(rawData)


Output = Output.replace('"', '\\"')
Output = Output.replace('\'', '\\"')
Output = Output.replace('&', ' and ')
Output = Output.replace('  and  ', ' and ')


print(Output)
