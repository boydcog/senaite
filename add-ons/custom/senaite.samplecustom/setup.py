from setuptools import setup, find_packages

setup(
    name='senaite.samplecustom',
    version='1.0.0',
    description="SENAITE Custom Addon for Sample Tube ID",
    packages=find_packages('src'),
    package_dir={'': 'src'},
    namespace_packages=['senaite'],
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        'setuptools',
        'senaite.core',
        'archetypes.schemaextender',
    ],
    entry_points="""
    # -*- Entry points: -*-
    [z3c.autoinclude.plugin]
    target = plone
    """,
)

