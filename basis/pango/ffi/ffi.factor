! Copyright (C) 2010 Anton Gorenko.
! See https://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.destructors alien.libraries
alien.syntax combinators gobject-introspection
gobject-introspection.standard-types system vocabs ;
IN: pango.ffi

<< "gobject.ffi" require >>

LIBRARY: pango

<< "pango" {
    { [ os windows? ] [ "libpango-1.0-0.dll" ] }
    { [ os macosx? ] [ "libpango-1.0.dylib" ] }
    { [ os unix? ] [ "libpango-1.0.so" ] }
} cond cdecl add-library >>

IMPLEMENT-STRUCTS: PangoRectangle ;

GIR: vocab:pango/Pango-1.0.gir

DESTRUCTOR: pango_font_description_free
DESTRUCTOR: pango_layout_iter_free

! <workaround

FORGET: pango_layout_line_index_to_x
FUNCTION: void
pango_layout_line_index_to_x ( PangoLayoutLine* line, gint index_, gboolean trailing, gint* x_pos )

FORGET: pango_layout_line_x_to_index
FUNCTION: gboolean
pango_layout_line_x_to_index ( PangoLayoutLine* line, gint x_pos, gint* index_, gint* trailing )

! workaround>
