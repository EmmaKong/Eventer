//
//  databaseService.h
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <sqlite3.h>
#import <Foundation/Foundation.h>
#import "_singleton.h"

@interface databaseService : NSObject
singleton_interface(databaseService);


- (BOOL)useDatabaseWithName:(NSString *)dbName;
- (BOOL)closeCurrentDatabase;
- (BOOL)createTableWithName:(NSString *)tbName withKeys:(NSMutableArray *)keys;
- (BOOL)insert:(NSDictionary *)insertInfo toTable:(NSString *)tbName;
- (BOOL)deleteFrom:(NSString *)tbName WithCondition:(NSDictionary *)condition;
- (BOOL)updateTable:(NSString *)tbName WithChanges:(NSDictionary *)newData AndConditions:(NSDictionary *)condition;
- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithCondition:(NSDictionary *)condition;
- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithCondition:(NSDictionary *)condition orderby:(NSDictionary *)order;
- (NSDictionary *)get:(NSString *)infoBeWanted top:(NSInteger)num FromTable:(NSString *)tbName WithCondition:(NSDictionary *)condition orderby:(NSDictionary *)order;
- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithCondition:(NSString*)condition RangeStart:(NSString *)start End:(NSString*)end;
- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithRangeCondition:(NSDictionary *)condition;
-(NSDictionary*)getCourseFromTableWithWeekday:(NSString *)weekday Week:(NSString*)currentWeek;
-(BOOL)createTableWithName:(NSString *)tbName withCondition:(NSDictionary *)condition;




@end

