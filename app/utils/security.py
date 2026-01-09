"""
密码安全工具

提供密码哈希和验证功能
"""
import bcrypt
import hashlib
import base64


def _pre_hash_password(password: str) -> str:
    """
    预处理密码：先使用 SHA256 哈希，再进行 Base64 编码。
    这解决了 bcrypt 的 72 字节限制问题，并防止 NULL 字节截断。
    """
    sha256_hash = hashlib.sha256(password.encode('utf-8')).digest()
    return base64.b64encode(sha256_hash).decode('utf-8')


def hash_password(password: str) -> str:
    """
    对密码进行哈希加密
    
    Args:
        password: 明文密码
        
    Returns:
        哈希后的密码
    """
    pwd_bytes = _pre_hash_password(password).encode('utf-8')
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(pwd_bytes, salt).decode('utf-8')


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    验证密码是否正确
    
    Args:
        plain_password: 明文密码
        hashed_password: 哈希密码
        
    Returns:
        密码是否匹配
    """
    pwd_bytes = _pre_hash_password(plain_password).encode('utf-8')
    hash_bytes = hashed_password.encode('utf-8')
    return bcrypt.checkpw(pwd_bytes, hash_bytes)
