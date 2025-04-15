python# setup.py
from setuptools import setup, find_packages

setup(
    name="atla-mcp-server",
    version="0.1.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    install_requires=[
        "mcp>=1.5.0",
        "atla>=0.1.0",
        "starlette>=0.28.0",
        "uvicorn>=0.23.0",
    ],
    python_requires=">=3.9",
)