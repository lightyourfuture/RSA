def extended_gcd(a, b):
    """扩展欧几里得算法，返回 (g, x, y)，使得 ax + by = g = gcd(a, b)"""
    if a == 0:
        return (b, 0, 1)
    else:
        g, x, y = extended_gcd(b % a, a)
        return (g, y - (b // a) * x, x)


def mod_inverse(e, phi):
    """求解模逆，返回 e 的模逆 (mod phi)"""
    g, x, y = extended_gcd(e, phi)
    if g != 1:
        raise Exception('模逆不存在')
    else:
        return x % phi


def main():
    p = 113680897410347
    q = 7999808077935876437321
    d = 22405534230753928650781647905

    phi = (p - 1) * (q - 1)
    e = mod_inverse(d, phi)

    print(f"e 的值是: {e}")


if __name__ == "__main__":
    main()
