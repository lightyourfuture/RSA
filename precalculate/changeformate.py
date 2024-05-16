# 十进制转十六进制
def changeformate(num):
    return hex(num)

# 十六进制转十进制
def changeformate2(num):
    return int(num, 16)

# 使用实例
print(changeformate(448274311462029954461165772101842599))
print(changeformate2('0x48656c6c6f20576f726c6421'))