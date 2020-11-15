/* Implementation of class NSGridView
   Copyright (C) 2020 Free Software Foundation, Inc.
   
   By: Gregory John Casamento
   Date: 08-08-2020

   This file is part of the GNUstep Library.
   
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
   
   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110 USA.
*/

#import <Foundation/NSArray.h>
#import "AppKit/NSGridView.h"

#import "GSFastEnumeration.h"

@interface NSGridRow (Private)
- (void) _setRow: (NSMutableArray *)row;
- (NSMutableArray *) _row;
@end

@interface NSGridColumn (Private)
- (void) _setColumn: (NSMutableArray *)col;
- (NSMutableArray *) _column;
@end

@implementation NSGridView

- (instancetype) initWithFrame: (NSRect)frameRect
{
  self = [super initWithFrame: frameRect];
  if (self != nil)
    {
      _rows = [[NSMutableArray alloc] initWithCapacity: 10];
    }
  return self;
}

- (instancetype) initWithViews: (NSArray *)rows
{
  self = [self initWithFrame: NSZeroRect];

  if (self != nil)
    {
      NSMutableArray *mutableRows = [rows mutableCopy];
      FOR_IN(NSMutableArray*, array, mutableRows)
        {
          [_rows addObject: array];
        }
      END_FOR_IN(mutableRows);
    }
  
  return self;
}

+ (instancetype) gridViewWithNumberOfColumns: (NSInteger)columnCount rows: (NSInteger)rowCount
{
  NSUInteger r = 0;
  NSUInteger c = 0;
  NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity: rowCount]; 

  for (r = 0; r < rowCount; r++)
    {
      NSMutableArray *col = [NSMutableArray arrayWithCapacity: columnCount];
      for (c = 0; c < columnCount; c++)
        {
          NSGridCell *gc = [[NSGridCell alloc] init];
          [col addObject: gc];
          RELEASE(gc);
        }
      [rows addObject: col];
    }
  
  return AUTORELEASE([self gridViewWithViews: rows]);
}

+ (instancetype) gridViewWithViews: (NSArray *)rows
{
  return [[self alloc] initWithViews: rows];
}

- (NSInteger) numberOfRows
{
  return [_rows count];
}

- (NSInteger) numberOfColumns
{
  return [[_rows objectAtIndex: 0] count];
}

- (NSGridRow *) rowAtIndex: (NSInteger)index
{
  NSGridRow *r = [[NSGridRow alloc] init];
  [r _setRow: [_rows objectAtIndex: index]];
  return r;
}

- (NSInteger) indexOfRow: (NSGridRow *)row
{
  return 0;
}

- (NSGridColumn *) columnAtIndex: (NSInteger)index
{
  return nil;
}

- (NSInteger) indexOfColumn: (NSGridColumn *)column
{
  return 0;
}

- (NSGridCell *) cellAtColumnIndex: (NSInteger)columnIndex rowIndex: (NSInteger)rowIndex
{
  return nil;
}

- (NSGridCell *) cellForView: (NSView*)view
{
  return nil;
}

- (NSGridRow *) addRowWithViews: (NSArray *)views
{
  return nil;
}

- (NSGridRow *) insertRowAtIndex: (NSInteger)index withViews: (NSArray *)views
{
  return nil;
}

- (void) moveRowAtIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex
{
}

- (void) removeRowAtIndex: (NSInteger)index
{
}

- (NSGridColumn *) addColumnWithViews: (NSArray*)views
{
  return nil;
}

- (NSGridColumn *) insertColumnAtIndex: (NSInteger)index withViews: (NSArray *)views
{
  return nil;
}

- (void) moveColumnAtIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex
{
}

- (void) removeColumnAtIndex: (NSInteger)index
{
}

- (NSGridCellPlacement) xPlacement
{
  return _xPlacement;
}

- (void) setXPlacement: (NSGridCellPlacement)x;
{
  _xPlacement = x;
}

- (NSGridCellPlacement) yPlacement;
{
  return _yPlacement;
}

- (void) setYPlacement: (NSGridCellPlacement)y;
{
  _yPlacement = y;
}

- (NSGridRowAlignment) rowAlignment;
{
  return _rowAlignment;
}

- (void) setRowAlignment: (NSGridRowAlignment)a;
{
  _rowAlignment = a;
}

- (CGFloat) rowSpacing
{
  return _rowSpacing;
}

- (void) setRowSpacing: (CGFloat)f
{
  _rowSpacing = f;
}

- (CGFloat) columnSpacing
{
  return _columnSpacing;
}

- (void) setColumnSpacing: (CGFloat)f
{
  _columnSpacing = f;
}
  
- (void) mergeCellsInHorizontalRange: (NSRange)hRange verticalRange: (NSRange)vRange
{
}

// coding
- (void) encodeWithCoder: (NSCoder *)coder
{
}

- (instancetype) initWithCoder: (NSCoder *)coder
{
  self = [super init];
  if ([coder allowsKeyedCoding])
    {
      if ([coder containsValueForKey: @"NSGrid_alignment"])
        {
          _rowAlignment = [coder decodeIntegerForKey: @"NSGrid_alignment"];
        }
      if ([coder containsValueForKey: @"NSGrid_columnSpacing"])
        {
          _columnSpacing = [coder decodeFloatForKey: @"NSGrid_columnSpacing"];
        }
      if ([coder containsValueForKey: @"NSGrid_columns"])
        {
          ASSIGN(_columns, [coder decodeObjectForKey: @"NSGrid_columns"]);
        }
      if ([coder containsValueForKey: @"NSGrid_rowSpacing"])
        {
          _rowSpacing = [coder decodeFloatForKey: @"NSGrid_rowSpacing"];
        }
      if ([coder containsValueForKey: @"NSGrid_rows"])
        {
          ASSIGN(_rows, [coder decodeObjectForKey: @"NSGrid_rows"]);
        }
      if ([coder containsValueForKey: @"NSGrid_xPlacement"])
        {
          _xPlacement = [coder decodeIntegerForKey: @"NSGrid_xPlacement"];
        }
      if ([coder containsValueForKey: @"NSGrid_yPlacement"])
        {
          _yPlacement = [coder decodeIntegerForKey: @"NSGrid_yPlacement"];
        }      
    }
  else
    {
    }
  return self;
}

@end


/// Cell ///
@implementation NSGridCell

- (NSView *) contentView
{
  return _contentView;
}

- (void) setContentView: (NSView *)v
{
  ASSIGN(_contentView, v);
}
  
+ (NSView *) emptyContentView
{
  return AUTORELEASE([[NSView alloc] initWithFrame: NSZeroRect]);
}

// Weak references to row/column
- (NSGridRow *) row
{
  return nil;
}

- (NSGridColumn *) column
{
  return nil;
}

// Placement
- (NSGridCellPlacement) xPlacement
{
  return 0;
}

- (void) setXPlacement: (NSGridCellPlacement)x
{
}

- (NSGridCellPlacement) yPlacement
{
  return 0;
}

- (void) setYPlacement: (NSGridCellPlacement)y
{
}

- (NSGridRowAlignment) rowAlignment
{
  return 0;
}

- (void) setRowAlignment: (NSGridRowAlignment)a
{
}

// Constraints
- (NSArray *) customPlacementConstraints
{
  return nil;
}

// coding
- (void) encodeWithCoder: (NSCoder *)coder
{
  if ([coder allowsKeyedCoding])
    {
    }
  else
    {
    }
}

- (instancetype) initWithCoder: (NSCoder *)coder
{
  self = [super init];
  if ([coder allowsKeyedCoding])
    {
    }
  else
    {
    }
  return self;
}

@end


/// Column ///
@implementation NSGridColumn

- (NSGridView *) gridView
{
  return nil;
}

- (NSInteger) numberOfCells
{
  return 0;
}

- (NSGridCell *) cellAtIndex:(NSInteger)index
{
  return nil;
}

- (NSGridCellPlacement) xPlacement
{
  return 0;
}

- (void) setXPlacement: (NSGridCellPlacement)x
{
}

- (CGFloat) width
{
  return 0.0;
}

- (void) setWidth: (CGFloat)f
{
}

- (CGFloat) leadingPadding
{
  return 0.0;
}

- (void) setLeadingPadding: (CGFloat)f
{
}

- (CGFloat) trailingPadding
{
  return 0.0;
}

- (void) setTrailingPadding: (CGFloat)f
{
}

- (BOOL) isHidden
{
  return NO;
}

- (void) mergeCellsInRange: (NSRange)range
{
}

// coding
- (void) encodeWithCoder: (NSCoder *)coder
{
}

- (instancetype) initWithCoder: (NSCoder *)coder
{
  self = [super init];
  if ([coder allowsKeyedCoding])
    {
      if ([coder containsValueForKey: @"NSGrid_hidden"])
        {
          _isHidden = [coder decodeBoolForKey: @"NSGrid_hidden"];
        }
      if ([coder containsValueForKey: @"NSGrid_leadingPadding"])
        {
          _leadingPadding = [coder decodeFloatForKey: @"NSGrid_leadingPadding"];
        }
      if ([coder containsValueForKey: @"NSGrid_owningGrid"])
        {
          _owningGrid = [coder decodeObjectForKey: @"NSGrid_owningGrid"];
        }
      if ([coder containsValueForKey: @"NSGrid_trailingPadding"])
        {
          _trailingPadding = [coder decodeFloatForKey: @"NSGrid_trailingPadding"];
        }
      if ([coder containsValueForKey: @"NSGrid_width"])
        {
          _width = [coder decodeFloatForKey: @"NSGrid_width"];
        }
      if ([coder containsValueForKey: @"NSGrid_xPlacement"])
        {
          _xPlacement = [coder decodeBoolForKey: @"NSGrid_xPlacement"];
        }      
    }
  else
    {
    }
  return self;
}

@end


/// Row ///
@implementation NSGridRow

- (void) _setRow: (NSMutableArray *)row
{
  _row = row; // weak reference;
}

- (NSMutableArray *) _row
{
  return _row;
}

- (BOOL) isEqual: (NSGridRow *)r
{
  if (_row == [r _row])
    {
      return YES;
    }
  else
    {
      NSUInteger idx = 0;
      FOR_IN(NSGridCell*, cell, _row)
        {
          NSGridCell *otherCell = [[r _row] objectAtIndex: idx];
          if (![cell isEqual: otherCell])
            {
              return NO;
            }
          idx++;
        }
      END_FOR_IN(_row);
    }
  return YES;
}

- (void) setGridView: (NSGridView *)gridView
{
  _gridView = gridView; // weak reference...
}

- (NSGridView *) gridView
{
  return _gridView;
}

- (NSInteger) numberOfCells
{
  return [_row count];
}

- (NSGridCell *) cellAtIndex:(NSInteger)index
{
  return [_row objectAtIndex: index];
}

- (NSGridCellPlacement) yPlacement
{
  return _yPlacement;
}

- (void) setYPlacement: (NSGridCellPlacement)y
{
  _yPlacement = y;
}

- (CGFloat) height
{
  return _height;
}

- (void) setHeight: (CGFloat)f
{
  _height = f;
}

- (CGFloat) topPadding
{
  return _topPadding;
}

- (void) setTopPadding: (CGFloat)f
{
  _topPadding = f;
}

- (CGFloat) bottomPadding
{
  return _bottomPadding;
}

- (void) setBottomPadding: (CGFloat)f
{
  _bottomPadding = f;
}

- (BOOL) isHidden
{
  return _isHidden;
}

- (void) setHidden: (BOOL)flag
{
  _isHidden = flag;
}

- (void) mergeCellsInRange: (NSRange)range
{
}

// coding
- (void) encodeWithCoder: (NSCoder *)coder
{
}

- (instancetype) initWithCoder: (NSCoder *)coder
{
  self = [super init];
  return self;
}

@end
