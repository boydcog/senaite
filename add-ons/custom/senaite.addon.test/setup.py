from setuptools import find_packages
from setuptools import setup

version = "0.1.0"

setup(
    name="senaite.addon.test",
    version=version,
    description="Test add-on for SENAITE",
    long_description="",
    packages=find_packages("src"),
    package_dir={"": "src"},
    namespace_packages=["senaite", "senaite.addon"],
    include_package_data=True,
    package_data={"": ["*.zcml", "*.xml"]},
    zip_safe=False,
    install_requires=["setuptools"],
    entry_points={
        "z3c.autoinclude.plugin": [
            "target = plone",
        ],
    },
)
