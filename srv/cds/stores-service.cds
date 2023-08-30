using { bookstore as db } from '../../db/schema';

service StoresService {
    @readonly entity Stores as projection on db.Stores;
}