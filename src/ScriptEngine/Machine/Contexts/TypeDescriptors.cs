using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScriptEngine.Machine.Contexts
{
    class SimpleEquatable<T>
    {
        protected SimpleEquatable()
        {
            _Equality = o => base.Equals(0);
            _HashFunc = () => base.GetHashCode();
        }

        protected SimpleEquatable(Func<T,bool> Equality, Func<int> HashFunc)
        {
            _Equality = Equality;
            _HashFunc = HashFunc;
        }

        protected Func<T, bool> _Equality;
        protected Func<int> _HashFunc;

        public override bool Equals(object obj)
        {
            return Equals((T)obj);
        }

        public bool Equals(T obj)
        {
            if (obj == null)
                return false;

            return _Equality(obj);
        }

        public override int GetHashCode()
        {
            return _HashFunc();
        }

        public static bool operator ==(SimpleEquatable<T> type1, T type2)
        {
            if (Object.ReferenceEquals(type1,null))
            {
                return Object.ReferenceEquals(type2, null);
            }
            else if (Object.ReferenceEquals(type2, null))
            {
                return false;
            }
            else
            {
                return type1.Equals(type2);
            }
        }

        public static bool operator !=(SimpleEquatable<T> type1, T type2)
        {
            if (Object.ReferenceEquals(type1, null))
            {
                return !Object.ReferenceEquals(type2, null);
            }
            else if (Object.ReferenceEquals(type2, null))
            {
                return true;
            }
            else
            {
                return !type1.Equals(type2);
            }

        }


    }

    public abstract class TypeQualifierContextBase : PropertyNameIndexAccessor
    {
        protected bool EqualsImpl<T>(IValue other, Func<T, bool> comparer) where T:class
        {
            var qualifier = other as T;
            if (qualifier == null)
                return false;

            return comparer(qualifier);

        }
    }

    public sealed class StringQualifier : TypeQualifierContextBase
    {
        public StringQualifier(int len, AvailableLengthType lenType = StringQualifier.AvailableLengthType.Variable) : base()
        {
            Lenght = len;
            AvailableLength = lenType;    
        }

        public override bool Equals(IValue qualifier)
        {
            return EqualsImpl<StringQualifier>(qualifier, (o)=>Lenght == o.Lenght && AvailableLength == o.AvailableLength);
        }
        
        public int Lenght { get; private set; }
        public AvailableLengthType AvailableLength { get; private set;}

        public enum AvailableLengthType
        {
            Variable,
            Fixed
        }

        public override string ToString()
        {
            if (AvailableLength == AvailableLengthType.Fixed)
            {
                return String.Format("str({0},fixed)", Lenght.ToString());
            }
            else
            {
                return String.Format("str({0})", Lenght.ToString());
            }
        }
    }

    sealed class V8NumberQualifier : SimpleEquatable<V8NumberQualifier>
    {

        public V8NumberQualifier(int IntegerPart, int Fraction = 0, bool NonNeg = false) : base()
        {
            IntegerDigits = IntegerPart;
            FractionDigits = Fraction;
            NonNegative = NonNeg;

            _Equality = (o) => IntegerDigits == o.IntegerDigits && FractionDigits == o.FractionDigits && NonNegative == o.NonNegative;
            _HashFunc = () => ToString().GetHashCode();

        }
        
        public int IntegerDigits { get; private set; }
        public int FractionDigits { get; private set; }
        public bool NonNegative { get; private set; }

        public override string ToString()
        {
            if(NonNegative)
                return String.Format("num({0},{1},non-negative)", IntegerDigits, FractionDigits);
            else
                return String.Format("num({0},{1})", IntegerDigits, FractionDigits);
        }

    }

    sealed class V8DateQualifier : SimpleEquatable<V8DateQualifier>
    {

        public V8DateQualifier(DateFractionsType dateFractions) : base()
        {
            DateFractions = dateFractions;

            _Equality = (o) => DateFractions == o.DateFractions;
            _HashFunc = () =>
                {
                    switch (DateFractions)
                    {
                        case DateFractionsType.Date:
                            return 2;
                        case DateFractionsType.Time:
                            return 1;
                        default:
                            return 0;
                    }
                };

        }

        public DateFractionsType DateFractions { get; private set; }

        public enum DateFractionsType
        {
            DateAndTime,
            Date,
            Time
        }

        public override string ToString()
        {
            switch (DateFractions)
            {
                case DateFractionsType.Date:
                    return "date()";
                case DateFractionsType.Time:
                    return "time()";
                default:
                    return ""; // datetime не требует доп. пояснений
            }
        }

    }

}
