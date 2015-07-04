//
//  databaseService.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "databaseService.h"
#import "_singleton.h"
@interface databaseService()
{
    sqlite3*db;
}
@end

@implementation databaseService
singleton_implementation(databaseService)


-(instancetype)init{
    databaseService *manager;
    if((manager=[super init]))
    {
        [manager useDatabaseWithName:@"eventer.db"];
    }
    return manager;
}



-(BOOL)useDatabaseWithName:(NSString*)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:dbName];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
        return YES;
    }else{
        NSLog(@"数据库打开成功");
        NSLog(@"%@",database_path);
        return NO;
    }
}

- (BOOL)closeCurrentDatabase
{
    sqlite3_close(db);
    return YES;
}

- (BOOL)createTableWithName:(NSString *)tbName withKeys:(NSMutableArray *)keys
{
    //    NSString *createTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO(ID INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT,imageDir TEXT,createDate TEXT)";
    NSString *createTable = @"CREATE TABLE IF NOT EXISTS ";
    createTable = [createTable stringByAppendingString:[NSString stringWithFormat:@"%@(ID INTEGER PRIMARY KEY AUTOINCREMENT,",tbName]];
    NSArray *allKeys = [keys copy];
    for (int i = 0; i < [allKeys count]; i++)
    {
        if (i == [allKeys count]-1) {
            createTable = [createTable stringByAppendingString:[NSString stringWithFormat:@"%@ TEXT)",[allKeys objectAtIndex:i]]];
            break;
        }
        createTable = [createTable stringByAppendingString:[NSString stringWithFormat:@"%@ TEXT,",[allKeys objectAtIndex:i]]];
    }
    
    BOOL result = [self execSql:createTable];
    return result;
}

- (BOOL)createTableWithName:(NSString *)tbName withCondition:(NSDictionary *)condition
{
    //    NSString *createTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO(ID INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT,imageDir TEXT,createDate TEXT)";
    NSString *createTable = @"CREATE TABLE IF NOT EXISTS ";
    createTable = [createTable stringByAppendingString:[NSString stringWithFormat:@"%@(ID INTEGER PRIMARY KEY AUTOINCREMENT,",tbName]];
    NSArray *allKeys = [condition allKeys];
    for (int i = 0; i < [allKeys count]; i++)
    {
        if (i == [allKeys count]-1) {
            NSString*key=[allKeys objectAtIndex:i];
            NSString*value=[condition objectForKey:key];
            createTable = [createTable stringByAppendingString:[NSString stringWithFormat:@"%@ %@)",key,value]];
            break;
        }else{
            NSString*key=[allKeys objectAtIndex:i];
            NSString*value=[condition objectForKey:key];
            createTable = [createTable stringByAppendingString:[NSString stringWithFormat:@"%@ %@,",key,value]];
        }
    }
    
    BOOL result = [self execSql:createTable];
    return result;
}



- (BOOL)insert:(NSDictionary *)insertInfo toTable:(NSString *)tbName
{
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO '%@' (",tbName];
    NSArray *allKeys = [insertInfo allKeys];
    
    for (int i = 0;i < [allKeys count]; i++) {
        if (i == [allKeys count]-1)
        {
            insert = [insert stringByAppendingString:[NSString stringWithFormat:@"'%@') VALUES (",[allKeys objectAtIndex:i]]];
            break;
        }
        insert = [insert stringByAppendingString:[NSString stringWithFormat:@"'%@',",[allKeys objectAtIndex:i]]];
    }
    
    for (int i = 0;i < [allKeys count]; i++) {
        if (i == [allKeys count]-1)
        {
            insert = [insert stringByAppendingString:[NSString stringWithFormat:@"'%@')",[insertInfo objectForKey:[allKeys objectAtIndex:i]]]];
            break;
        }
        insert = [insert stringByAppendingString:[NSString stringWithFormat:@"'%@',",[insertInfo objectForKey:[allKeys objectAtIndex:i]]]];
    }

    
    BOOL result = [self execSql:insert];

    return result;
}

- (BOOL)deleteFrom:(NSString *)tbName WithCondition:(NSDictionary *)condition
{
    NSString *delete =[NSString string];
    if (condition==nil) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@ ",tbName];
    }else{
        delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ",tbName];
        NSArray *allKeys = [condition allKeys];
        for(int i = 0;i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            if (i == [allKeys count]-1)
            {
                delete = [delete stringByAppendingString:[NSString stringWithFormat:@"%@='%@'",key,[condition objectForKey:key]]];
                break;
            }
            delete = [delete stringByAppendingString:[NSString stringWithFormat:@"%@='%@',",key,[condition objectForKey:key]]];
        }}
    NSLog(@"delete:%@",delete);
    BOOL result = [self execSql:delete];
    return result;
}

-(BOOL)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
        return NO;
    }
    return YES;
}

- (BOOL)updateTable:(NSString *)tbName WithChanges:(NSDictionary *)newData AndConditions:(NSDictionary *)condition
{
    if (!newData) {
        return NO;
    }
    NSString *update = [NSString stringWithFormat:@"UPDATE %@ set ",tbName];
    NSArray *allKeys = [newData allKeys];
    for(int i = 0;i < [allKeys count]; i++)
    {
        NSString *key = [allKeys objectAtIndex:i];
        if (i == [allKeys count]-1)
        {
            update = [update stringByAppendingString:[NSString stringWithFormat:@"%@='%@'",key,[newData objectForKey:key]]];
            break;
        }
        update = [update stringByAppendingString:[NSString stringWithFormat:@"%@='%@',",key,[newData objectForKey:key]]];
    }
    if (condition)
    {
        update = [update stringByAppendingString:@" WHERE "];
        allKeys = [condition allKeys];
        for(int i = 0;i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            if (i == [allKeys count]-1)
            {
                update = [update stringByAppendingString:[NSString stringWithFormat:@"%@='%@'",key,[condition objectForKey:key]]];
                break;
            }
            update = [update stringByAppendingString:[NSString stringWithFormat:@"%@='%@' AND ",key,[condition objectForKey:key]]];
        }
    }
    NSLog(@"%@",update);
    BOOL result = [self execSql:update];
    return result;
}

- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithCondition:(NSDictionary *)condition
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *select;
    
    if (![infoBeWanted isEqualToString:@"ALL"])
        select = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@",infoBeWanted,tbName];
    else
        select = [NSString stringWithFormat:@"SELECT DISTINCT * FROM %@",tbName];
    NSArray *allKeys = [condition allKeys];
    
    if (condition)
    {
        select = [select stringByAppendingString:@" WHERE "];
        for(int i = 0;i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            if (i == [allKeys count]-1)
            {
                select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",key,[condition objectForKey:key]]];
                break;
            }
            select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@',",key,[condition objectForKey:key]]];
        }
    }
        NSLog(@"%@",select);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [select UTF8String], -1, &statement, Nil)==SQLITE_OK)
    {
        int ID = 1;
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int i = 0;
//            if([infoBeWanted isEqualToString:@"ALL"])
//                i++;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (; (char*)sqlite3_column_name(statement,i);i++)
            {
                //获取key和value放入返回的NSDictionary中
                char *keyName = (char*)sqlite3_column_name(statement, i);
                NSString *keyNameStr = [NSString stringWithUTF8String:keyName];
                char *value = (char*)sqlite3_column_text(statement, i);
                if (value!=NULL)
                {
                    NSString *valueStr = [NSString stringWithUTF8String:value];
                    [dic setValue:valueStr forKey:keyNameStr];
                }else
                {
                    [dic setValue:NULL forKey:keyNameStr];
                }
            }
            [result setObject:dic forKey:[NSString stringWithFormat:@"%d",ID]];
            ID++;
        }
    }

    NSLog(@"%@",result);

    return [result copy];
}

- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithRangeCondition:(NSDictionary *)condition{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *select;
    
    if (![infoBeWanted isEqualToString:@"ALL"])
        select = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@",infoBeWanted,tbName];
    else
        select = [NSString stringWithFormat:@"SELECT DISTINCT * FROM %@",tbName];
    NSArray *allKeys = [condition allKeys];
    
    if (condition)
    {
        select = [select stringByAppendingString:@" WHERE "];
        for(int i = 0;i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            if (i == [allKeys count]-1)
            {
                select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ <= %@",key,[condition objectForKey:key]]];
                break;
            }
            select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ >= %@ AND ",key,[condition objectForKey:key]]];
        }
    }
    NSLog(@"%@",select);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [select UTF8String], -1, &statement, Nil)==SQLITE_OK)
    {
        int ID = 1;
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int i = 0;
//            if([infoBeWanted isEqualToString:@"ALL"])
//                i++;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (; (char*)sqlite3_column_name(statement,i);i++)
            {
                //获取key和value放入返回的NSDictionary中
                char *keyName = (char*)sqlite3_column_name(statement, i);
                NSString *keyNameStr = [NSString stringWithUTF8String:keyName];
                char *value = (char*)sqlite3_column_text(statement, i);
                if (value!=NULL)
                {
                    NSString *valueStr = [NSString stringWithUTF8String:value];
                    [dic setValue:valueStr forKey:keyNameStr];
                }else
                {
                    [dic setValue:NULL forKey:keyNameStr];
                }
            }
            [result setObject:dic forKey:[NSString stringWithFormat:@"%d",ID]];
            ID++;
        }
    }
    
    NSLog(@"%@",result);
    
    return [result copy];
}



- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithCondition:(NSString*)condition RangeStart:(NSString *)start End:(NSString*)end{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *select;

    if (![infoBeWanted isEqualToString:@"ALL"])
        select = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@ WHERE %@ BETWEEN %@ AND %@",infoBeWanted,tbName,condition,start,end];
    else
        select = [NSString stringWithFormat:@"SELECT DISTINCT * FROM %@ WHERE %@ BETWEEN %@ AND %@",tbName,condition,start,end];
    
    NSLog(@"%@",select);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [select UTF8String], -1, &statement, Nil)==SQLITE_OK)
    {
        int ID = 1;
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int i = 0;
//            if([infoBeWanted isEqualToString:@"ALL"])
//                i++;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (; (char*)sqlite3_column_name(statement,i);i++)
            {
                //获取key和value放入返回的NSDictionary中
                char *keyName = (char*)sqlite3_column_name(statement, i);
                NSString *keyNameStr = [NSString stringWithUTF8String:keyName];
                char *value = (char*)sqlite3_column_text(statement, i);
                if (value!=NULL)
                {
                    NSString *valueStr = [NSString stringWithUTF8String:value];
                    [dic setValue:valueStr forKey:keyNameStr];
                }else
                {
                    [dic setValue:NULL forKey:keyNameStr];
                }
            }
            [result setObject:dic forKey:[NSString stringWithFormat:@"%d",ID]];
            ID++;
        }
    }
    
    NSLog(@"%@",result);
    
    return [result copy];
}



- (NSDictionary *)get:(NSString *)infoBeWanted FromTable:(NSString *)tbName WithCondition:(NSDictionary *)condition orderby:(NSDictionary *)order{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *select;
    
    if (![infoBeWanted isEqualToString:@"ALL"])
        select = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@",infoBeWanted,tbName];
    else
        select = [NSString stringWithFormat:@"SELECT DISTINCT * FROM %@",tbName];
    NSArray *allKeys = [condition allKeys];
    
    if (condition)
    {
        select = [select stringByAppendingString:@" WHERE "];
        for(int i = 0;i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            if (i == [allKeys count]-1)
            {
                select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",key,[condition objectForKey:key]]];
                break;
            }
            select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@',",key,[condition objectForKey:key]]];
        }
    }
    
    NSArray*orderkeys=[order allKeys];
    
    if (order)
    {
        select = [select stringByAppendingString:@" ORDER BY "];
        for(int i = 0;i < [orderkeys count]; i++)
        {
            NSString *key = [orderkeys objectAtIndex:i];
            if (i == [orderkeys count]-1)
            {
                select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ %@",key,[order objectForKey:key]]];
                break;
            }
            select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ %@,",key,[order objectForKey:key]]];
        }
    }
        NSLog(@"%@",select);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [select UTF8String], -1, &statement, Nil)==SQLITE_OK)
    {
        int ID = 1;
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int i = 0;
//            if([infoBeWanted isEqualToString:@"ALL"])
//                i++;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (; (char*)sqlite3_column_name(statement,i);i++)
            {
                //获取key和value放入返回的NSDictionary中
                char *keyName = (char*)sqlite3_column_name(statement, i);
                NSString *keyNameStr = [NSString stringWithUTF8String:keyName];
                char *value = (char*)sqlite3_column_text(statement, i);
                if (value!=NULL)
                {
                    NSString *valueStr = [NSString stringWithUTF8String:value];
                    [dic setValue:valueStr forKey:keyNameStr];
                }else
                {
                    [dic setValue:NULL forKey:keyNameStr];
                }
            }
            [result setObject:dic forKey:[NSString stringWithFormat:@"%d",ID]];
            ID++;
        }
    }

    NSLog(@"%@",result);

    return [result copy];
    
}

- (NSDictionary *)get:(NSString *)infoBeWanted top:(NSInteger)num FromTable:(NSString *)tbName WithCondition:(NSDictionary *)condition orderby:(NSDictionary *)order
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *select;
    
    if (![infoBeWanted isEqualToString:@"ALL"])
        select = [NSString stringWithFormat:@"SELECT DISTINCT TOP %ld %@ FROM %@",(long)num,infoBeWanted,tbName];
    else
        select = [NSString stringWithFormat:@"SELECT DISTINCT TOP %ld * FROM %@",(long)num,tbName];
    NSArray *allKeys = [condition allKeys];
    
    if (condition)
    {
        select = [select stringByAppendingString:@" WHERE "];
        for(int i = 0;i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            if (i == [allKeys count]-1)
            {
                select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",key,[condition objectForKey:key]]];
                break;
            }
            select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@',",key,[condition objectForKey:key]]];
        }
    }
    
    NSArray*orderkeys=[order allKeys];
    
    if (order)
    {
        select = [select stringByAppendingString:@" ORDER BY "];
        for(int i = 0;i < [orderkeys count]; i++)
        {
            NSString *key = [orderkeys objectAtIndex:i];
            if (i == [orderkeys count]-1)
            {
                select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ %@",key,[order objectForKey:key]]];
                break;
            }
            select = [select stringByAppendingString:[NSString stringWithFormat:@"%@ %@,",key,[order objectForKey:key]]];
        }
    }
        NSLog(@"%@",select);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [select UTF8String], -1, &statement, Nil)==SQLITE_OK)
    {
        int ID = 1;
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int i = 0;
            //            if([infoBeWanted isEqualToString:@"ALL"])
            //                i++;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (; (char*)sqlite3_column_name(statement,i);i++)
            {
                //获取key和value放入返回的NSDictionary中
                char *keyName = (char*)sqlite3_column_name(statement, i);
                NSString *keyNameStr = [NSString stringWithUTF8String:keyName];
                char *value = (char*)sqlite3_column_text(statement, i);
                if (value!=NULL)
                {
                    NSString *valueStr = [NSString stringWithUTF8String:value];
                    [dic setValue:valueStr forKey:keyNameStr];
                }else
                {
                    [dic setValue:NULL forKey:keyNameStr];
                }
            }
            [result setObject:dic forKey:[NSString stringWithFormat:@"%d",ID]];
            ID++;
        }
    }

    NSLog(@"%@",result);

    return [result copy];
    
}



//select * from dbCourse where [primary_key] not in (select [primary_key] where FIND_IN_SET('NoClassWeek',NoClassWeek))
-(NSDictionary*)getCourseFromTableWithWeekday:(NSString *)weekday Week:(NSString*)currentWeek{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString*select=[NSString stringWithFormat:@"SELECT * FROM dbCourse WHERE CourseID NOT IN (SELECT CourseID WHERE FIND_IN_SET('%@',NoClassWeek)) AND %@ >= StartWeek AND %@ <= EndWeek AND weekDay = %@",currentWeek,currentWeek,currentWeek,weekday];
    NSLog(@"%@",select);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [select UTF8String], -1, &statement, Nil)==SQLITE_OK)
    {
        int ID = 1;
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int i = 0;
            //            if([infoBeWanted isEqualToString:@"ALL"])
            //                i++;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (; (char*)sqlite3_column_name(statement,i);i++)
            {
                //获取key和value放入返回的NSDictionary中
                char *keyName = (char*)sqlite3_column_name(statement, i);
                NSString *keyNameStr = [NSString stringWithUTF8String:keyName];
                char *value = (char*)sqlite3_column_text(statement, i);
                if (value!=NULL)
                {
                    NSString *valueStr = [NSString stringWithUTF8String:value];
                    [dic setValue:valueStr forKey:keyNameStr];
                }else
                {
                    [dic setValue:NULL forKey:keyNameStr];
                }
            }
            [result setObject:dic forKey:[NSString stringWithFormat:@"%d",ID]];
            ID++;
        }
    }
    
    NSLog(@"%@",result);
    
    return [result copy];

}


@end

